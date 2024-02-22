import 'package:flutter/material.dart';
import 'package:loan_calculator/constants/app_text.dart';
import 'package:loan_calculator/module/emi/emi_result_screen.dart';
import 'package:loan_calculator/theme/app_colors.dart';
import 'package:loan_calculator/theme/app_text_style.dart';
import 'package:loan_calculator/widgets/app_text_form_field.dart';
import 'package:loan_calculator/widgets/primary_button.dart';
import 'package:loan_calculator/widgets/rounded_border_button.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  TextEditingController loanAmount = TextEditingController();
  TextEditingController interest = TextEditingController();
  TextEditingController loanTenure = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int isSlider = 0;

  @override
  void initState() {
    super.initState();
    loanAmount.text = '10000';
    interest.text = '12';
    loanTenure.text = '5';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'EMI ${AppText.calculator}',
            style: AppTextStyle.semiBold22,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TabBar(
                  labelColor: AppColors.whiteColor,
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(12),
                  splashFactory: NoSplash.splashFactory,
                  unselectedLabelColor: AppColors.textColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primaryColor,
                  ),
                  onTap: (value) {
                    setState(() {
                      isSlider = value;
                    });
                  },
                  tabs: const [
                    Tab(
                      child: Text("Slider"),
                    ),
                    Tab(
                      child: Text("Input Filed"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Card(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          commonFiled(
                            title: AppText.loanAmount,
                            controller: loanAmount,
                            min: 100,
                            max: 100000,
                            maxLength: 6,
                            symbol: AppText.rupeeSymbol,
                            textAlign: TextAlign.left,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return 'Minimum value allowed is 100';
                              } else if (int.parse(p0) > 100000) {
                                return 'Maximum value allowed is 100000';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          commonFiled(
                            title: AppText.rateOfInterest,
                            controller: interest,
                            min: 1,
                            max: 30,
                            maxLength: 3,
                            symbol: AppText.percentageSymbol,
                            textAlign: TextAlign.left,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return 'Minimum value allowed is 1';
                              } else if (double.parse(p0) > 30) {
                                return 'Maximum value allowed is 30';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          commonFiled(
                            title: AppText.timePeriod,
                            controller: loanTenure,
                            min: 1,
                            max: 30,
                            maxLength: 2,
                            symbol: AppText.yearSymbol,
                            textAlign: TextAlign.left,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return 'Minimum value allowed is 1';
                              } else if (int.parse(p0) > 30) {
                                return 'Maximum value allowed is 30';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          bottomButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commonFiled({
    required String title,
    required String symbol,
    required int maxLength,
    required double min,
    required double max,
    required TextAlign? textAlign,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    // required Function(String? value) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.regular16,
            ),
            if (isSlider == 0)
              const SizedBox(
                width: 30,
              ),
            if (isSlider == 0)
              SizedBox(
                width: 150,
                child: FiledWithSuffix(
                  enabled: false,
                  maxLength: maxLength,
                  controller: controller,
                  symbol: symbol,
                  validator: validator,
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        isSlider == 0
            ? SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbColor: AppColors.whiteColor,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: AppColors.highlightColor,
                ),
                child: Slider(
                  label: title,
                  value: controller.text.isEmpty
                      ? min
                      : double.parse(controller.text) < min
                          ? min
                          : double.parse(controller.text) > max
                              ? max
                              : double.parse(controller.text),
                  onChanged: (value) {
                    setState(() {
                      controller.text = value.round().toString();
                    });
                  },
                  min: min,
                  max: max,
                ),
              )
            : FiledWithSuffix(
                maxLength: maxLength,
                controller: controller,
                textAlign: textAlign,
                symbol: symbol,
                validator: validator,
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: RoundedBorderButton(
            text: AppText.reset,
            tColor: AppColors.primaryColor,
            onTap: () {
              setState(() {
                loanAmount.text = '10000';
                interest.text = '12';
                loanTenure.text = '5';
              });
            },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: PrimaryButton(
            text: AppText.calculate,
            tColor: AppColors.whiteColor,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmiResultScreen(
                              investment: int.parse(loanAmount.text),
                              returnRate: double.parse(interest.text),
                              time: int.parse(loanTenure.text),
                            )));
              }
            },
          ),
        ),
      ],
    );
  }
}

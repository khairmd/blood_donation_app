
import '../settings_controller.dart';
import '../../../widgets/custom_drop_down_button.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  SettingsController get controller => Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(text: 'Edit Profile', showBackIcon: true),
      body: Obx(
        () => CustomLoader(
          isTrue: AppGlobals.isLoading.value,
          child: Stack(
            children: [
              // 1. Background Image (fixed at the bottom of the stack)
              Positioned.fill(
                // Makes the image fill the entire available space
                child: Obx(
                  () => Image.asset(
                    // Use Image.asset directly
                    AppGlobals.isDarkMode.value
                        ? AppConstants.profileBgDark
                        : AppConstants.profileBgLight,
                    fit:
                        BoxFit.cover, // Ensures the image covers the whole area
                    // alignment: Alignment.center, // Optional: adjust alignment if needed
                  ),
                ),
              ),
              // 2. Content (scrollable on top of the background)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: profileFormKey,
                    child: Column(
                      children: [
                        20.verticalSpace,

                        ///Profile Image
                        Obx(
                          () => Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.loose,
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:
                                        controller.imageFile != null
                                            ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: FileImage(
                                                controller.imageFile!,
                                              ),
                                            )
                                            : controller.profilePicture.isNotEmpty
                                            ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                controller.profilePicture.value,
                                              ),
                                            )
                                            : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                AppConstants.profilePlaceHolder,
                                              ),
                                            ),
                                  ),
                                ),
                                // Edit Icon
                                Visibility(
                                  visible: true,
                                  child: Positioned(
                                    right: -4,
                                    bottom: 2,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await controller.pickImage();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///Full Name
                        CustomTextFormField(
                          controller: controller.fullNameTFController,
                          prefixIcon: SvgPicture.asset(AppConstants.profile),
                          upperLabel: "Full Name",
                          upperLabelReqStar: "*",
                          hintValue: "Enter Full Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full Name is required';
                            }
                            return null; // Return null if the input is valid
                          },
                          maxLines: 1,
                        ),

                        ///User Name
                        CustomTextFormField(
                          readOnly: true,
                          controller: controller.userNameTFController,
                          prefixIcon: SvgPicture.asset(AppConstants.profile),
                          upperLabel: "User Name",
                          upperLabelReqStar: "*",
                          hintValue: "Enter User Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User Name is required';
                            }
                            return null; // Return null if the input is valid
                          },
                          maxLines: 1,
                        ),

                        ///Email
                        CustomTextFormField(
                          readOnly: true,
                          controller: controller.emailTFController,
                          prefixIcon: SvgPicture.asset(AppConstants.mail),
                          upperLabel: "Email Address",
                          upperLabelReqStar: "*",
                          hintValue: "Enter Email Address",
                          validator: (value) => validateEmail(value),
                          type: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter(
                              RegExp(r'[a-zA-Z0-9@._-]'),
                              allow: true,
                            ),
                          ],
                          maxLines: 1,
                        ),

                        ///Date Of Birth
                        InkWell(
                          onTap: () async {
                            controller.pickDate();
                          },
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                              controller: controller.dOBTFController,
                              prefixIcon: SvgPicture.asset(AppConstants.calendar),
                              upperLabel: "Date Of Birth",
                              upperLabelReqStar: "*",
                              hintValue: "Tap to select Date Of Birth",
                              validator: (value) => validateInputData(value,true),
                              type: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9@._-]'),
                                  allow: true,
                                ),
                              ],
                              maxLines: 1,
                            ),
                          ),
                        ),
                        10.verticalSpace,

                        /// Gender
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            'Gender',
                            style: AppTextTheme.bodyMedium,
                          ),
                        ),
                        5.verticalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropDownButton(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: SvgPicture.asset(AppConstants.gender),
                              ),
                              width: Get.width,
                              initialValue:
                              controller.genderTFController.text.isEmpty
                                  ? 'Choose One'
                                  : controller.genderTFController.text,
                              items: ['Choose One', 'Male', 'Female'],
                              onChanged: (value) {
                                controller.genderTFController.text = value;
                              },
                            ),
                          ],
                        ),
                        20.verticalSpace,

                        ///Edit Profile Button
                        CustomRectangleButton(
                          width: Get.width,
                          text: "Update",
                          onTap: () {
                            if (!profileFormKey.currentState!.validate()) {
                              return;
                            }
                            controller.updateProfile();
                          },
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

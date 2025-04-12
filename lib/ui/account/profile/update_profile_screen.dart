import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_my_app/core/ui/custom_app_bar.dart';
import 'package:new_my_app/core/ui/form_field_widget.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.viewModel});
  final AccountViewmodel viewModel;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _hasChanges = false;


  @override
  void initState() {
    super.initState();
    widget.viewModel.updateProfile.addListener(_onResult);
    _firstNameController.addListener(_onFieldChange);
    _lastNameController.addListener(_onFieldChange);
    _addressController.addListener(_onFieldChange);
    _firstNameController.text = widget.viewModel.user?.firstName ?? '';
    _lastNameController.text = widget.viewModel.user?.lastName ?? '';
    _addressController.text = widget.viewModel.user?.address ?? '';

    widget.viewModel.load.addListener(_onLoadComplete);
  }

  @override
  void didUpdateWidget(covariant UpdateProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.updateProfile.removeListener(_onResult);
    oldWidget.viewModel.load.removeListener(_onLoadComplete);
    widget.viewModel.updateProfile.addListener(_onResult);
    widget.viewModel.load.addListener(_onLoadComplete);

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    widget.viewModel.updateProfile.removeListener(_onResult);
    // widget.viewModel.load.removeListener(_onLoadComplete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Update Profile",
        showBackButton: true,
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [ 
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: const Color.fromRGBO(255, 255, 252, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: FormFieldWidget(
                                        controller: _firstNameController,
                                        label: "First Name",
                                        errorMessage: "Please enter first name",
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FormFieldWidget(
                                        controller: _lastNameController,
                                        label: "Last Name",
                                        errorMessage: "Please enter last name",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                FormFieldWidget(
                                  controller: _addressController,
                                  label: "Address",
                                  errorMessage: "Please enter address",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: InkWell(
                          onTap: _hasChanges ? () => handleUpdateProfile() : null,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _hasChanges ? 
                              const Color.fromRGBO(16, 35, 64, 1) : const Color.fromRGBO(184, 184, 184, 1),
                              // const Color.fromRGBO(16, 35, 64, 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Center(
                              child: Text(
                                'Save changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            ListenableBuilder(
              listenable: widget.viewModel.updateProfile,
              builder: (context, _) {
                if (widget.viewModel.updateProfile.running) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(16, 35, 64, 1),
                      ),
                    ),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      )
    );
  }
  
  handleUpdateProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String address = _addressController.text;
    
      widget.viewModel.updateProfile.execute(
        UpdateProfileRequest(
          firstName: firstName,
          lastName: lastName,
          address: address,
        )
      );

    }
  }

  void _onFieldChange() {
    final String currentFirstName = _firstNameController.text;
    final String currentLastName = _lastNameController.text;
    final String currentAddress = _addressController.text;
    
    final bool hasChanges = currentFirstName != (widget.viewModel.user?.firstName ?? '') ||
        currentLastName != (widget.viewModel.user?.lastName ?? '') ||
        currentAddress != (widget.viewModel.user?.address ?? '');
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _onLoadComplete() {
    if (widget.viewModel.load.completed && widget.viewModel.user != null) {
      _firstNameController.text = widget.viewModel.user?.firstName ?? '';
      _lastNameController.text = widget.viewModel.user?.lastName ?? '';
      _addressController.text = widget.viewModel.user?.address ?? '';
    }else {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _addressController.text = '';
    }
  }

  void _onResult() {
    if (widget.viewModel.updateProfile.completed) {
      widget.viewModel.updateProfile.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop();
    }

    if (widget.viewModel.updateProfile.error) {
      widget.viewModel.updateProfile.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
        ),
      );
    }
  }
}

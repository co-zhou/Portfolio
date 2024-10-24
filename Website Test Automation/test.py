from seleniumbase import BaseCase

BaseCase.main(__name__, __file__)

class MyTestClass(BaseCase):
    def login(self):
        print("Login")
        self.open("https://www.mysonicwall.com/muir/login")
        self.maximize_window()
        self.assert_title("Login")
        self.type("#username", "coreyzh@gmail.com")
        self.click("#nextButton")
        self.type("#password", "TestPassword@123")
        self.click(".s-login-button")
        self.click(".s-link")
        self.assert_title("MySonicWall")

##    def test_user_group(self):
##        self.login()
##        print("Go To User Group")
##        self.click("#md-button-toggle-4")
##        self.switch_to_frame("id-iframe-workspace")
##        
##        print("Create User Group")
##        self.click("span.create-user-group__new_user_group_font")
##        self.type("input[name=new_user_group]", "Test User Group")
##        self.click(".icon-checkmark")
##        
##        self.assert_element_present("span.create-user-group__list_name[title='Test User Group']")
##
##        print("Add User To User Group")
##        self.click("span.user-group-extension__no-user__action")
##        self.click("span.create-user__invite_font")
##        self.click(".sw-select")
##        self.click("div[id^=sw-select__option-]:first-of-type")
##        self.type("name=inviteUserFirstName", "First Name")
##        self.type("name=inviteUserLastName", "Last Name")
##        self.type("name=inviteUserEmailId", "Email@gmail.com")
##        self.click(".sw-btn--default")
##
##        self.assert_text("First Name Last Name", "div:nth-child(1) > div > .user-group-extension_user_name")
##
##        print("Remove User")
##        self.click("div.user-group-extension__user_grid_template__remove_user")
##
##        print("Delete User Group")
##        self.hover_and_click("span.create-user-group__list_name[title='Test User Group']", "span.sw-icon__inner.sw-font-icon.icon-trash")
##        self.click(".sw-action-bar > div:nth-child(2) > button")
##
##        self.assert_element_absent("span.create-user-group__list_name[title='Test User Group']")
##
##        print("Remove User from User List")
##        self.click(".sw-tab:nth-child(2) .sw-tab__inner__piece")
##        self.click(".icon-trash")
##        self.click(".sw-action-bar-item:nth-child(2) > .sw-btn")

    def test_products(self):
        self.login()
        print("Products")
        self.click("#md-button-toggle-2")
        self.switch_to_frame("id-iframe-workspace")
        
        self.assert_text("All tenants", ".dropdown-three-component__label-text")

    def test_register_products(self):
        self.login()
        print("Register Products")
        self.click("#md-button-toggle-3")
        self.switch_to_frame("id-iframe-workspace")
        
        self.assert_text("Register Products", ".register-product__heading")

    def test_download_center(self):
        self.login()
        print("Download Center")
        self.click(".icon-download")
        self.click("#md-button-toggle-12")

        self.assert_text("Download Center", ".second-level")

    def test_support(self):
        self.login()
        print("Support")
        self.click(".icon-phone:nth-child(1)")
        self.click("#md-button-toggle-19")
        self.switch_to_frame("id-iframe-workspace")

        self.assert_text("Support", ".mswAppTitle__Wrapper--text")

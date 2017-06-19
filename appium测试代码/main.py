# -*- coding: utf-8 -*-

from appium import webdriver

# 引入刚刚创建的同目录下的desired_capabilities.py
import desired_capabilities

# 我们使用python的unittest作为单元测试工具
from unittest import TestCase

# 我们使用python的unittest作为单元测试工具
import unittest

# 使用time.sleep(xx)函数进行等待
import time


class MqcTest(TestCase):
    def setUp(self):
        # 获取我们设定的capabilities，通知Appium Server创建相应的会话。
        desired_caps = desired_capabilities.get_desired_capabilities()
        # 获取server的地址
        uri = desired_capabilities.get_uri()
        # 创建会话，得到driver对象，driver对象封装了所有的设备操作。
        self.driver = webdriver.Remote(uri, desired_caps)
        # 等待app完全加载
        time.sleep(3)




    #    # 第2个用例，登录
    def test_case_b_login(self):

        # 第1个用例，如果检测到弹框，就点掉


        # 点击我注册账户
        leftBtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='我']")
        leftBtn.click()
        time.sleep(1)

        try :
            loginbtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='登陆/注册']")
            loginbtn.click()
            time.sleep(1)
            login(self)

        except :
            pass
            Me7(self)




    def tearDown(self):
         # 测试结束，退出会话
         self.driver.quit()
    # 预约启动
def Me1(self):
    leftBtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='我']")
    leftBtn.click()
    time.sleep(1)
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[1]")
    el.click()
    time.sleep(1)
# 消息中心
def Me2(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[2]")
    el.click()
    time.sleep(1)
# 账户安全
def Me3(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[3]")
    el.click()
    time.sleep(1)
# 车辆资料
def Me4(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[4]")
    el.click()
    time.sleep(1)
# 终端资料
def Me5(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[5]")
    el.click()
    time.sleep(1)
# 终端管理
def Me6(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[6]")
    el.click()
    time.sleep(1)
# 在线客服
def Me7(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[7]")
    el.click()
    time.sleep(2)
    textfield = self.driver.find_element_by_class_name("XCUIElementTypeTextView")
    camera = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='bt camera']")
    sendbtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='发送']")
    textfield.click()
    # textfield.send_keys("fdsfdsfdsfdsgdsgjrgwrdqwr")
    textfield.setvalue("fdsfdsfdsfdsgdsgjrgwrdqwr".decode('UTF-8'))
    time.sleep(1)

    sendbtn.click()
    time.sleep(1)
    textfield.send_keys("pokpmksfmjkhtemflmwdkldsfkldckmsfdsfdsfafd".decode('UTF-8'))
    sendbtn.click()
    time.sleep(1)
    textfield.send_keys("dpofpofjkfldksfldclms,dmklfmldsfl;dksfioekfremwrkehjrimfkdnfksfldksfkdsfa".decode('UTF-8'))
    sendbtn.click()
    time.sleep(1)
    textfield.send_keys("flllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll".decode('UTF-8'))
    sendbtn.click()
    time.sleep(1)

    camera.click()
    time.sleep(1)
    cancel = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='取消']")
    cancel.click()
    time.sleep(1)

    camera.click()
    time.sleep(1)
    album = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='从手机相册选择']")
    album.click()
    time.sleep(1)

    cancel1 = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='取消']")
    cancel1.click()
    time.sleep(1)

    camera.click()
    time.sleep(1)
    album = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='从手机相册选择']")
    album.click()
    time.sleep(1)

    cell1 = self.driver.find_element_by_xpath("//XCUIElementTypeCell[1]")
    cell1.click()
    time.sleep(1)

    cell11 = self.driver.find_element_by_xpath("//XCUIElementTypeCell[2]")
    cell11.click()
    time.sleep(2)


# 关于我们
def Me8(self):
    el = self.driver.find_element_by_xpath("//XCUIElementTypeCell[8]")
    el.click()
    time.sleep(1)



# 登录
def login(self):
    namefield = self.driver.find_element_by_class_name("XCUIElementTypeTextField")
    pwdfield = self.driver.find_element_by_class_name("XCUIElementTypeSecureTextField")
    namefield.clear()
    namefield.send_keys("15310911351".decode('UTF-8'))
    time.sleep(1)
    pwdfield.send_keys("123456".decode('UTF-8'))
    time.sleep(1)

    # donebtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='完成' or @label='Done']")
    # if donebtn :
    #     donebtn.click()
    #     time.sleep(1)
    self.driver.hide_keyboard()

    encryptedbtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='ic encrypted']")
    if encryptedbtn:
        encryptedbtn.click()
        time.sleep(1)
        encryptedbtn.click()
        time.sleep(1)
        encryptedbtn.click()
        time.sleep(1)
        encryptedbtn.click()
        time.sleep(1)

    donebtn = self.driver.find_element_by_xpath("//XCUIElementTypeButton[@label='登录']")
    if donebtn:
        donebtn.click()
        time.sleep(2)


def case_a_dismiss_alert(self):
            while True:
                time.sleep(1)
                alertEle = self.driver.find_elements_by_class_name("XCUIElementTypeAlert")
                if alertEle:
                    print 'find an alert'
                    allowBtn = self.driver.find_element_by_xpath(
                        "//XCUIElementTypeButton[@label='允许' or @label='Allow' or @label='确定']")
                    allowBtn.click()
                else:
                    break

if __name__ == '__main__':
    try:
       unittest.main()
    except SystemExit:
       pass

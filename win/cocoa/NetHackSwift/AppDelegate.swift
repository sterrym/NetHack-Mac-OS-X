//
//  AppDelegate.swift
//  NetHackSwift
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Cocoa

let kNetHackOptions = "kNetHackOptions"


func SwiftInitNHWindows(argc: UnsafeMutablePointer<Int32>, argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>) {
	
}

func SwiftPlayerSelection() {
	
}

func SwiftAskName() {
	
}

func SwiftGetNHEvent() {
	
}

func SwiftExitNHWindows(str: UnsafePointer<Int8>) {
	
}

func SwiftSuspendNHWindows(str: UnsafePointer<Int8>) {
	
}

func SwiftResumeNHWindows() {
	
}

func SwiftCreateNHWindow(type: Int32) -> winid {
	return 0
}

func SwiftClearNHWindow(wid: winid) {
	
}

func SwiftDisplayNHWindow(wid: winid, block: Int32) {
	
}

func SwiftDestroyNHWindow(wid: winid) {
	
}

func SwiftCurs(wid: winid, x: Int32, y: Int32) {
	
}

func SwiftPutStr(wid: winid, attr: Int32, text: UnsafePointer<Int8>) {
	
}

func SwiftDisplayFile(filename: UnsafePointer<Int8>, must_exist: Int32) {
	
}

func SwiftStartMenu(wid: winid) {
	
}

func SwiftAddMenu(wid: winid, glypn: Int32, identifier: UnsafePointer<any>, accelerator: Int32, groupAccel: Int32, attr: Int32, str: UnsafePointer<Int8>, presel: Int32) {
	
}

func SwiftEndMenu(wid: winid, prompt: UnsafePointer<Int8>) {
	
}

func SwiftSelectMenu(wid: winid, how: Int32, selected: UnsafeMutablePointer<UnsafeMutablePointer<menu_item>>) -> Int32 {
	return 0
}

func SwiftUpdateInventory() {
	
}

func SwiftMarkSynch() {
	
}

func SwiftWaitSynch() {
	
}

func SwiftClipAround(x: Int32, y: Int32) {
	
}

func SwiftPrintGlyph(wid: winid, x: Int32, y: Int32, glyph: Int32) {
	
}

func swiftRawPrint(str: UnsafePointer<Int8>, bold: Bool) {
	
}

func SwiftRawPrint(str: UnsafePointer<Int8>) {
	swiftRawPrint(str, bold: false)
}

func SwiftRawPrintBold(str: UnsafePointer<Int8>) {
	swiftRawPrint(str, bold: true)
}

func SwiftNHGetCh() -> Int32 {
	return 0
}

func SwiftNHPosKey(x: UnsafeMutablePointer<Int32>, y: UnsafeMutablePointer<Int32>, mod: UnsafeMutablePointer<Int32>) -> Int32 {
	return 0
}

func SwiftNHBell() {
	NSLog("nhbell")
	NSBeep()
}

func SwiftDoPrevMessage() -> Int32 {
	
	return 0
}

func SwiftYNFunction(question: UnsafePointer<Int8>, choices: UnsafePointer<Int8>, def: Int32) -> Int8 {
	return 0
}

func SwiftGetLine(prompt: UnsafePointer<Int8>, line: UnsafeMutablePointer<Int8>) {
	
}

func SwiftGetExtCommand() -> Int32 {
	return 0
}

func SwiftNumberPad(num: Int32) {
	
}

func SwiftDelayOutput() {
	//NSLog(@"delay_output");
	usleep(50000);
}

func SwiftStartScreen() {
	NSLog("start_screen");
}

func SwiftEndScreen() {
	NSLog("end_screen");
}

func SwiftOutRIP(wid: winid, how: Int32) {
	NSLog("outrip %x", wid);
}

func SwiftPreferenceUpdate(pref: UnsafePointer<Int8>) {
	
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	override init() {
		cocoa_procs.name = UnsafePointer<Int8>(strdup("swift"))
		cocoa_procs.wincap = UInt(WC_COLOR|WC_HILITE_PET |
		WC_ASCII_MAP|WC_TILED_MAP |
		WC_FONT_MAP|WC_TILE_FILE|WC_TILE_WIDTH|WC_TILE_HEIGHT |
		WC_PLAYER_SELECTION|WC_SPLASH_SCREEN)
		cocoa_procs.win_init_nhwindows = SwiftInitNHWindows
		cocoa_procs.win_player_selection = SwiftPlayerSelection
		cocoa_procs.win_askname = SwiftAskName
		cocoa_procs.win_get_nh_event = SwiftGetNHEvent
		cocoa_procs.win_exit_nhwindows = SwiftExitNHWindows
		cocoa_procs.win_suspend_nhwindows = SwiftSuspendNHWindows
		cocoa_procs.win_resume_nhwindows = SwiftResumeNHWindows
		cocoa_procs.win_create_nhwindow = SwiftCreateNHWindow
		cocoa_procs.win_clear_nhwindow = SwiftClearNHWindow
		cocoa_procs.win_display_nhwindow = SwiftDisplayNHWindow
		cocoa_procs.win_destroy_nhwindow = SwiftDestroyNHWindow
		cocoa_procs.win_curs = SwiftCurs
		cocoa_procs.win_putstr = SwiftPutStr
		cocoa_procs.win_display_file = SwiftDisplayFile
		cocoa_procs.win_start_menu = SwiftStartMenu
		cocoa_procs.win_add_menu = SwiftAddMenu
		cocoa_procs.win_end_menu = SwiftEndMenu
		cocoa_procs.win_select_menu = SwiftSelectMenu
		cocoa_procs.win_message_menu = genl_message_menu
		cocoa_procs.win_update_inventory = SwiftUpdateInventory
		cocoa_procs.win_mark_synch = SwiftMarkSynch
		cocoa_procs.win_wait_synch = SwiftWaitSynch
		cocoa_procs.win_cliparound = SwiftClipAround
		cocoa_procs.win_print_glyph = SwiftPrintGlyph
		cocoa_procs.win_raw_print = SwiftRawPrint
		cocoa_procs.win_raw_print_bold = SwiftRawPrintBold
		cocoa_procs.win_nhgetch = SwiftNHGetCh
		cocoa_procs.win_nh_poskey = SwiftNHPosKey
		#if DEBUG
			cocoa_procs.win_nhbell = SwiftNHBell
		#else
			cocoa_procs.win_nhbell = NSBeep
		#endif
		cocoa_procs.win_doprev_message = SwiftDoPrevMessage
		cocoa_procs.win_yn_function = SwiftYNFunction
		cocoa_procs.win_getlin = SwiftGetLine
		cocoa_procs.win_get_ext_cmd = SwiftGetExtCommand
		cocoa_procs.win_number_pad = SwiftNumberPad
		cocoa_procs.win_delay_output = SwiftDelayOutput
		cocoa_procs.win_start_screen = SwiftStartScreen
		cocoa_procs.win_end_screen = SwiftEndScreen
		cocoa_procs.win_outrip = SwiftOutRIP
		cocoa_procs.win_preference_update = SwiftPreferenceUpdate
		
		super.init()
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}


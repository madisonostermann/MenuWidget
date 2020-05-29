//
//  ViewController.swift
//  MenuWidget
//
//  Created by Madison Gipson on 5/29/20.
//  Copyright © 2020 Madison Gipson. All rights reserved.
//

import SwiftUI

// Uniform button style to be used on each element in the menu widget.
struct PageButtonStyle: ButtonStyle {
    let buttonSize = UIScreen.main.bounds.width*0.12
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .foregroundColor(Color.white)
            .frame(width: buttonSize, height: buttonSize) //sets the frame for the button, not the icon
            .background(Color.green)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ViewController: View {
    @State var page:String = "ViewA" //default view
    @State var icon:String = "a.circle.fill" //icon for current screen- default corresponds to default view
    let screenSize = UIScreen.main.bounds //constant to reference the screensize
    @State var expand:Bool = false //if you're selecting the screen, show the whole menu... if not, collapse
    let iconSize = UIScreen.main.bounds.width*0.07 //frame for the icon; set smaller than that of the button it's on
    @State private var rightSide:Bool = true //should menu be on right or left
    
    // gesture recognizer that changes the xOffset & yOffset if the menu is dragged far enough across the screen
    var menuDrag: some Gesture {
        DragGesture().onChanged { value in }.onEnded { value in
            //if menu is on right side and gets dragged to the left half of the screen
            //OR if menu is on left side and gets dragged to the right half of the screen
            //toggle 'rightSide' so the menu moves to the other side of the screen
            if (self.rightSide && value.translation.width < -(self.screenSize.width*0.5)) ||
                (!self.rightSide && value.translation.width > self.screenSize.width*0.5) {
                self.rightSide.toggle()
            }
        }
    }
    
    var body: some View {
        ZStack { //contains page vstack & menu widget zstack
            //one page is shown at a time depending on what "page" is- changes when buttons are tapped
            VStack {
                if page == "ViewA" {
                    ViewA()
                }
                if page == "ViewB" {
                    ViewB()
                }
                if page == "ViewC" {
                    ViewC()
                }
            } //end of page vstack
            ZStack { //layers page and menu widget on top of each other (z-axis)
                //menu widget buttons are stacked vertically- could be changed to horizontally with HStack
                VStack {
                    if expand { //if you're selecting the screen, all should appear... otherwise just the current should
                        //ViewA
                        Button(action: {
                            self.page = "ViewA" //ViewA button tapped -> change "page" to ViewA
                            self.icon = "a.circle.fill" //icon for current page
                        }) {
                            //set button icon to one that corresponds with the page it'll trigger
                            //have to add resizable() in order for frame() to make a difference
                            Image(systemName: "a.circle.fill").resizable().frame(width: iconSize, height: iconSize)
                        }.buttonStyle(PageButtonStyle()).cornerRadius(15) //use uniform buttonstyle and round edges
                        //ViewB
                        Button(action: {
                            self.page = "ViewB"
                            self.icon = "b.circle.fill"
                        }) {
                            Image(systemName: "b.circle.fill").resizable().frame(width: iconSize, height: iconSize)
                        }.buttonStyle(PageButtonStyle()).cornerRadius(15)
                        //ViewC
                        Button(action: {
                            self.page = "ViewC"
                            self.icon = "c.circle.fill"
                        }) {
                            Image(systemName: "c.circle.fill").resizable().frame(width: iconSize, height: iconSize)
                        }.buttonStyle(PageButtonStyle()).cornerRadius(15)
                    }
                    //Chevron/Current Screen- which icon shows depends on if the screen is being selected or not
                    Button(action: {
                        self.expand.toggle() //changes which menu buttons are shown
                    }) {
                        //if you're selecting the screen show the chevron, if not show the icon for the current page
                        //if you're selecting the screen the chevron's height should shrink so it's not un-proportional
                        Image(systemName: expand ? "chevron.up" : icon).resizable().frame(width: iconSize, height: expand ? iconSize/3 : iconSize)
                        }.buttonStyle(PageButtonStyle()).cornerRadius(15).animation(.spring()).gesture(menuDrag) //add animation to the button so chevron/icon shrinks/stretches, and add menuDrag gesture so if it's dragged the menu moves
                }.padding([.all]).animation(.spring()).gesture(menuDrag) //end of button vstack
                //add animation to the menu vstack so it fades in/out, and add menuDrag gesture so if any of the vstack is dragged the menu moves
            }.frame(width: screenSize.width, height: screenSize.height, alignment: rightSide ? .bottomTrailing : .bottomLeading) //end of button zstack
            //have alignment change to trailing (rightside) or leading (leftside) depending on the value of "rightSide"
        } //end of view zstack
    } //end of view
} //end of struct


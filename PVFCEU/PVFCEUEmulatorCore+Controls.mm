//
//  PVFCEUEmulatorCore+Controls.m
//  PVFCEU-iOS
//
//  Created by Joseph Mattiello on 11/3/18.
//  Copyright © 2018 Provenance Emu. All rights reserved.
//

#import "PVFCEUEmulatorCore+Controls.h"
#import "PVFCEUEmulatorCore.h"

#include "FCEU/fceu.h"
#include "FCEU/driver.h"
#include "FCEU/input.h"
#include "FCEU/sound.h"
#include "FCEU/movie.h"
#include "FCEU/palette.h"
#include "FCEU/state.h"
#include "FCEU/emufile.h"

static const int NESMap[] = {JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT, JOY_A, JOY_B, JOY_START, JOY_SELECT};

@implementation PVFCEUEmulatorCore (Controls)

# pragma mark - Input

- (void)didPushNESButton:(PVNESButton)button forPlayer:(NSInteger)player {
    int playerShift = player != 0 ? 8 : 0;

    pad[player][0] |= NESMap[button] << playerShift;
}

- (void)didReleaseNESButton:(PVNESButton)button forPlayer:(NSInteger)player {
    int playerShift = player != 0 ? 8 : 0;

    pad[player][0] &= ~NESMap[button] << playerShift;
}

- (void)updateControllers {
    for (NSInteger playerIndex = 0; playerIndex < 2; playerIndex++)
    {
        GCController *controller = nil;
        int playerShift = playerIndex != 0 ? 8: 0;

        if (self.controller1 && playerIndex == 0)
        {
            controller = self.controller1;
        }
        else if (self.controller2 && playerIndex == 1)
        {
            controller = self.controller2;
        }

        if ([controller extendedGamepad])
        {
            GCExtendedGamepad *gamepad = [controller extendedGamepad];
            GCControllerDirectionPad *dpad = [gamepad dpad];

            (dpad.up.isPressed || gamepad.leftThumbstick.up.isPressed) ? pad[playerIndex][0] |= JOY_UP << playerShift : pad[playerIndex][0] &= ~JOY_UP << playerShift;
            (dpad.down.isPressed || gamepad.leftThumbstick.down.isPressed) ? pad[playerIndex][0] |= JOY_DOWN << playerShift : pad[playerIndex][0] &= ~JOY_DOWN << playerShift;
            (dpad.left.isPressed || gamepad.leftThumbstick.left.isPressed) ? pad[playerIndex][0] |= JOY_LEFT << playerShift : pad[playerIndex][0] &= ~JOY_LEFT << playerShift;
            (dpad.right.isPressed || gamepad.leftThumbstick.right.isPressed) ? pad[playerIndex][0] |= JOY_RIGHT << playerShift : pad[playerIndex][0] &= ~JOY_RIGHT << playerShift;

            (gamepad.buttonA.isPressed || gamepad.buttonY.isPressed) ? pad[playerIndex][0] |= JOY_B << playerShift : pad[playerIndex][0] &= ~JOY_B << playerShift;
            (gamepad.buttonX.isPressed || gamepad.buttonB.isPressed) ? pad[playerIndex][0] |= JOY_A << playerShift : pad[playerIndex][0] &= ~JOY_A << playerShift;

            (gamepad.leftShoulder.isPressed || gamepad.leftTrigger.isPressed) ? pad[playerIndex][0] |= JOY_SELECT << playerShift : pad[playerIndex][0] &= ~JOY_SELECT << playerShift;
            (gamepad.rightShoulder.isPressed || gamepad.rightTrigger.isPressed) ? pad[playerIndex][0] |= JOY_START << playerShift : pad[playerIndex][0] &= ~JOY_START << playerShift;
        }
        else if ([controller gamepad])
        {
            GCGamepad *gamepad = [controller gamepad];
            GCControllerDirectionPad *dpad = [gamepad dpad];

            dpad.up.isPressed ? pad[playerIndex][0] |= JOY_UP << playerShift : pad[playerIndex][0] &= ~JOY_UP << playerShift;
            dpad.down.isPressed ? pad[playerIndex][0] |= JOY_DOWN << playerShift : pad[playerIndex][0] &= ~JOY_DOWN << playerShift;
            dpad.left.isPressed ? pad[playerIndex][0] |= JOY_LEFT << playerShift : pad[playerIndex][0] &= ~JOY_LEFT << playerShift;
            dpad.right.isPressed ? pad[playerIndex][0] |= JOY_RIGHT << playerShift : pad[playerIndex][0] &= ~JOY_RIGHT << playerShift;

            (gamepad.buttonA.isPressed || gamepad.buttonY.isPressed) ? pad[playerIndex][0] |= JOY_B << playerShift : pad[playerIndex][0] &= ~JOY_B << playerShift;
            (gamepad.buttonX.isPressed || gamepad.buttonB.isPressed) ? pad[playerIndex][0] |= JOY_A << playerShift : pad[playerIndex][0] &= ~JOY_A << playerShift;

            gamepad.leftShoulder.isPressed ? pad[playerIndex][0] |= JOY_SELECT << playerShift : pad[playerIndex][0] &= ~JOY_SELECT << playerShift;
            gamepad.rightShoulder.isPressed ? pad[playerIndex][0] |= JOY_START << playerShift : pad[playerIndex][0] &= ~JOY_START << playerShift;
        }
#if TARGET_OS_TV
        else if ([controller microGamepad])
        {
            GCMicroGamepad *gamepad = [controller microGamepad];
            GCControllerDirectionPad *dpad = [gamepad dpad];

            (dpad.up.value > 0.5) ? pad[playerIndex][0] |= JOY_UP << playerShift : pad[playerIndex][0] &= ~JOY_UP << playerShift;
            (dpad.down.value > 0.5) ? pad[playerIndex][0] |= JOY_DOWN << playerShift : pad[playerIndex][0] &= ~JOY_DOWN << playerShift;
            (dpad.left.value > 0.5) ? pad[playerIndex][0] |= JOY_LEFT << playerShift : pad[playerIndex][0] &= ~JOY_LEFT << playerShift;
            (dpad.right.value > 0.5) ? pad[playerIndex][0] |= JOY_RIGHT << playerShift : pad[playerIndex][0] &= ~JOY_RIGHT << playerShift;

            gamepad.buttonX.isPressed ? pad[playerIndex][0] |= JOY_B << playerShift : pad[playerIndex][0] &= ~JOY_B << playerShift;
            gamepad.buttonA.isPressed ? pad[playerIndex][0] |= JOY_A << playerShift : pad[playerIndex][0] &= ~JOY_A << playerShift;
        }
#endif
    }
}

@end

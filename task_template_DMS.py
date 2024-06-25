# %%
"""
Delayed-Match-Sampling Task (DMS) Task designed and written by 
Yuen Siang Ang, DPhil (Institute of High Performance Computing) 

"""

# Make sure these parameters are correct
param_filename = 'parameters_temp.csv'  # Filename of parameters
fullScreen = True  # True if use full screen mode
screenSize   = (1024, 768)  # The screen 

from psychopy import core, visual, gui, data, event
from psychopy.tools.filetools import fromFile, toFile
import numpy, random
import pandas as pd
import csv

expName = 'DMS'
expInfo = {u'participant': u'test', u'Block': u'1'}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False: core.quit()  # if pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

# print(expInfo)
Subject = expInfo['participant']
Block = int(expInfo['Block'])
print('Subject: {}'.format(Subject))
print('Block: {}'.format(Block))

# make a text file to save data
fileName = expInfo['participant']
dataFile = open(fileName+'.csv', 'w')  # a simple text file with 'comma-separated-values'
#dataFile.write('trial,correct,rt\n')

# Screen setting
screenWidth  = screenSize[0]
screenHeight = screenSize[1]

# Setup the Window
win = visual.Window(size=[screenWidth, screenHeight], fullscr=fullScreen, 
    units='height',
    monitor='testMonitor'
    )

# %%
"""
Load target -> Present target -> Load responses -> Present responses
A: Stimulus
B: Response
C: Feedback 
Average Trial time = 0.5 + 8 + <2> + 1 + 1
"""

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
runClock = core.Clock()

# Read parameters [trial, target, foil, delay]
with open(param_filename, newline='') as f:
    reader = csv.reader(f)
    params = list(reader)
#print(params)
#print(len(params))
    
# display instructions and wait
message1 = visual.TextStim(win, text='Hit a key when ready.', height=0.1)
message1.draw()
win.flip() 
event.waitKeys() #pause until there's a keypress

runClock.reset()
blank = visual.TextStim(win, text=' ', height=0.2)
fixation = visual.TextStim(win, text='+', height=0.2)
correct_scr = visual.TextStim(win, text='Correct', height=0.2)
incorrect_scr = visual.TextStim(win, text='Incorrect', height=0.2)

# Present fixation screen for 1s
stopTimeInSeconds_blank0 = runClock.getTime()+1
while runClock.getTime()<stopTimeInSeconds_blank0:
    fixation.draw()
    win.flip()

outputs = [] # trialnr, targetPresentTime, blank1PresentTime, responseStartTime, blank2PresentTime, feedbackTime,correct, rt

for trial in range(0,len(params)):    
    
    # Define target and foil stimuli for this trial
    target_stim = visual.ImageStim(win, image=params[trial][1])
    foil_stim = visual.ImageStim(win, image=params[trial][2])

    # Present target for 0.5s
    targetPresentTime = core.getAbsTime()
    stopTimeInSeconds_target = runClock.getTime()+0.5
    while runClock.getTime()<stopTimeInSeconds_target:
        target_stim.draw()
        win.flip()
    
    # Present blank screen for Ns
    blank1PresentTime = core.getAbsTime()
    delay = int(params[trial][3])
    stopTimeInSeconds_blank1 = runClock.getTime()+delay
    while runClock.getTime()<stopTimeInSeconds_blank1:
        blank.draw()
        win.flip()
        
    # Present possible response options
    # set location of target & foil stimuli
    targetSide= random.choice([-1,1])  # will be either +1(right) or -1(left)
    foil_stim.setPos([-0.4*targetSide, 0])
    target_stim.setPos([0.4*targetSide, 0])  # in other location
    respDone = False
    responseStartTime = core.getAbsTime()
    respPhaseStartTime = runClock.getTime()
    while respDone == False:
        target_stim.draw()
        foil_stim.draw()
        win.flip()
        # Get response
        correct = None
        while correct == None:
            allKeys = event.waitKeys()
            for thisKey in allKeys:
                if thisKey=='left':
                    respDone = True
                    if targetSide==-1: 
                        correct = 1    # correct
                        rt = runClock.getTime()-respPhaseStartTime
                    else: 
                        correct = 0   # incorrect
                        rt = runClock.getTime()-respPhaseStartTime
                elif thisKey=='right':
                    respDone = True
                    if targetSide==1: 
                        correct = 1    # correct
                        rt = runClock.getTime()-respPhaseStartTime
                    else: 
                        correct = 0   # incorrect
                        rt = runClock.getTime()-respPhaseStartTime
                elif thisKey in ['q', 'escape']:
                    core.quit() # abort experiment
            event.clearEvents() # clear other (eg mouse) events - they clog the buffer
     
    #outputs.append([trial+1,targetPresentTime,blank1PresentTime,responseStartTime,correct,rt])
    
    # Present blank screen for 1s
    blank2PresentTime = core.getAbsTime()
    stopTimeInSeconds_blank1 = runClock.getTime()+1
    while runClock.getTime()<stopTimeInSeconds_blank1:
        blank.draw()
        win.flip()
    
    # Present feedback for 1 sec
    feedbackTime = core.getAbsTime()
    stopTimeInSeconds_feedback = runClock.getTime()+1
    while runClock.getTime()<stopTimeInSeconds_feedback:
        if correct==1: correct_scr.draw()
        else: incorrect_scr.draw()
        win.flip()
    
    # Present fixation screen for 1s
    stopTimeInSeconds_blank0 = runClock.getTime()+1
    while runClock.getTime()<stopTimeInSeconds_blank0:
        fixation.draw()
        win.flip()
    
    outputs.append([trial+1,targetPresentTime,blank1PresentTime,responseStartTime,blank2PresentTime,feedbackTime,correct,rt])

print(outputs)
df_outputs = pd.DataFrame(outputs)
df_outputs.columns = ['trial','TargetPresentTime','blank1PresentTime','responseStartTime','blank2PresentTime','feedbackTime','correct','rt']
df_outputs.to_csv(dataFile)

win.close()
    
    
    
    
    
    

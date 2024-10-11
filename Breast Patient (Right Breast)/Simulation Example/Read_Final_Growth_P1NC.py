from abaqus import *
import sys
from odbAccess import *
import numpy as np
from abaqusConstants import *
from visualization import *

# Integration point coordinates at first time step
pts = np.loadtxt('P1NC_Skin_Integration_Points.txt')
pts = np.array(pts)
pts_len = len(pts)
pts = pts.astype(np.float32)
increments = np.linspace(11590, 11590, 1)
increments = increments.astype(np.int32)

num_sim = 40
for tmp in range(num_sim):
    if tmp == 1 or tmp == 2 or tmp == 3 or tmp == 6 or tmp == 7 or tmp == 8 or tmp == 10 or tmp == 11 or tmp == 15 or tmp == 17 or tmp == 18 or tmp == 19 or tmp == 20 or tmp == 21 or tmp == 22 or tmp == 24 or tmp == 25 or tmp == 27 or tmp == 28 or tmp == 30 or tmp == 32 or tmp == 34 or tmp == 37 or tmp == 38:
        tmp = tmp
    else:
        odbPath = 'P1NC_ExpJob' + str(tmp+1)+'.odb'
        th_data = np.zeros([len(increments), pts_len])
        thg_data = np.zeros([len(increments), pts_len])
        row = 0

        o1 = session.openOdb(name=odbPath)
        odb = session.odbs[odbPath]
        session.viewports['Viewport: 1'].setValues(displayedObject=o1)

        for increment in increments:

            session.viewports['Viewport: 1'].odbDisplay.setFrame(
                step=0, frame=increment)
            session.viewports['Viewport: 1'].odbDisplay.basicOptions.setValues(
                averageElementOutput=False)
            session.Path(name='Path-1', type=POINT_LIST, expression=(pts))
            pth = session.paths['Path-1']

            session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
                variableLabel='SDV1', outputPosition=INTEGRATION_POINT)

            thetag = session.XYDataFromPath(name='XYData-1', path=pth, includeIntersections=False, projectOntoMesh=False,
                                            pathStyle=PATH_POINTS, numIntervals=10, projectionTolerance=0, shape=UNDEFORMED, labelType=TRUE_DISTANCE)

            thetagRawIntPtValues = [tup[1] for tup in thetag]

            thetagElemValues = []
            counter = 0
            tempSum = 0
            # iterate through all integration point values which come out in sets of 8 in the order that
            # elements are defined
            for i in range(len(thetagRawIntPtValues)):
                tempSum += thetagRawIntPtValues[i]
                counter += 1
                if counter == 8:
                    counter = 0
                    thetagElemValues.append(tempSum/8)
                    tempSum = 0

            # Save raw growth at all integration points
            np.savetxt('P1NC_thg_raw_intPt_data_Sim_' +
                       str(tmp+1) + 'V3.txt', thetag, fmt='%.6f')

            np.savetxt('P1NC_thg_elem_data_Sim_' + str(tmp+1) +
                       'V3.txt', thetagElemValues, fmt='%.6f')

            del session.xyDataObjects['XYData-1']

            session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
                variableLabel='SDV3', outputPosition=INTEGRATION_POINT)
            theta = session.XYDataFromPath(name='XYData-1', path=pth, includeIntersections=False, projectOntoMesh=False,
                                           pathStyle=PATH_POINTS, numIntervals=10, projectionTolerance=0, shape=UNDEFORMED, labelType=TRUE_DISTANCE)

            thetaRawIntPtValues = [tup[1] for tup in theta]

            thetaElemValues = []
            counter = 0
            tempSum = 0
            # iterate through all integration point values which come out in sets of 8 in the order that
            # elements are defined
            for i in range(len(thetaRawIntPtValues)):
                tempSum += thetaRawIntPtValues[i]
                counter += 1
                if counter == 8:
                    counter = 0
                    thetaElemValues.append(tempSum/8)
                    tempSum = 0

            # save raw deformation data at all integration points
            np.savetxt('P1NC_th_raw_intPt_data_Sim_' +
                       str(tmp+1) + 'V3.txt', theta, fmt='%.6f')

            # save deformation data at all elements
            np.savetxt('P1NC_th_elem_data_Sim_' + str(tmp+1) +
                       'V3.txt', thetaElemValues, fmt='%.6f')

            del session.xyDataObjects['XYData-1']
            row += 1

        session.odbs[odbPath].close()

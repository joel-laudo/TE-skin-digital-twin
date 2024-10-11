from abaqus import *
import sys
from odbAccess import *
import numpy as np
from abaqusConstants import *
from visualization import *

# Integration point coordinates at first time step
pts = np.loadtxt('P1NC_Top_Layer_Coords_Cutout_trimmed.txt')
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
                variableLabel='COORD', refinement=[COMPONENT, 'COOR1'], outputPosition=NODAL)

            XcoordsWithPath = session.XYDataFromPath(name='XYData-1', path=pth, includeIntersections=False, projectOntoMesh=False,
                                                     pathStyle=PATH_POINTS, numIntervals=10, projectionTolerance=0, shape=UNDEFORMED, labelType=TRUE_DISTANCE)

            Xcoords = [tup[1] for tup in XcoordsWithPath]
            Xcoords = np.array(Xcoords)
            #Xcoords = Xcoords.transpose()

            del session.xyDataObjects['XYData-1']

            session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
                variableLabel='COORD', refinement=[COMPONENT, 'COOR2'], outputPosition=NODAL)
            YcoordsWithPath = session.XYDataFromPath(name='XYData-1', path=pth, includeIntersections=False, projectOntoMesh=False,
                                                     pathStyle=PATH_POINTS, numIntervals=10, projectionTolerance=0, shape=UNDEFORMED, labelType=TRUE_DISTANCE)

            Ycoords = [tup[1] for tup in YcoordsWithPath]
            Ycoords = np.array(Ycoords)
            #Ycoords = Ycoords.transpose()

            del session.xyDataObjects['XYData-1']

            session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
                variableLabel='COORD', refinement=[COMPONENT, 'COOR3'], outputPosition=NODAL)
            ZcoordsWithPath = session.XYDataFromPath(name='XYData-1', path=pth, includeIntersections=False, projectOntoMesh=False,
                                                     pathStyle=PATH_POINTS, numIntervals=10, projectionTolerance=0, shape=UNDEFORMED, labelType=TRUE_DISTANCE)

            Zcoords = [tup[1] for tup in ZcoordsWithPath]
            Zcoords = np.array(Zcoords)
            #Zcoords = Zcoords.transpose()

            DeformedCoords = np.array([Xcoords, Ycoords, Zcoords])
            DeformedCoords = DeformedCoords.transpose()
            np.savetxt('P1NC_Deformed_Coords_Sim_' +
                       str(tmp+1) + 'V3_trimmed.txt', DeformedCoords)
        session.odbs[odbPath].close()

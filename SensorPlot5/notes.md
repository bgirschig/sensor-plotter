# Problems and (some of the) solutions

## discrepancies between piezzo sensors readings
piezzo elements (PE) are polarised

**Solution**:	`connect the PEs in the same direction`

## unreliable signal
when connecting the PEs directly to arduino's analog-in pins, the readings were unreliable, and appeared truncated. Using the Aref pin to increase precision did not solve the problem.

**Solution**:	`amplify the signal **before** sending it to arduino`

## finding position from signals
When trying to deduce the position of the tap from the direct comparision of signals from the sensors, the results 
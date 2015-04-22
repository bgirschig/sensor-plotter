# Problems and (some of the) solutions

## discrepancies between piezzo sensors readings
piezzo elements (PE) are polarised

**Solution**:	`connect the PEs in the same direction`

## unreliable signal
when connecting the PEs directly to arduino's analog-in pins, the readings were unreliable, and appeared truncated. Using the Aref pin to increase precision did not solve the problem.

**Solution**:	`amplify the signal **before** sending it to arduino`

## finding position from signals
When trying to deduce the position of the tap from the direct comparision of signals from the sensors, the results were terrible. Not only did the method of substracting one signal from the other not precise, it was almost completely random.
The solution seem to be:
- Detect then compare peaks.
- values should be
	- difference from the average (for auto calibration)
	- unsigned (the first peak is sometimes positive, sometimes negative. only its force should count).

## CAUTION: the first peak is not always the most powerful
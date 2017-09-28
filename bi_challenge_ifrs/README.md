# Coya Business Intelligence challenge - Insurance P&L
One of the colleagues asked you how to read a profit-and-loss statement of an insurance company

Using the following dataset
https://www.aviva.com/media/upload/ifrs.xlsx

# Question 1) How would you explain the net earned premium figure calculation?

## Probably on an example: 
Let's take a motor insurance policy (one year coverage) which starts on 1.11.2017 and has a total premium of 480 EUR. There are different options on how to pay premium in terms of frequency = one payment at the start for the whole policy or for example quarterly or monthly but typically many clients go with one annual payment at the start of the policy. Let's assume we have a annual premium paid at the start. Also let's assume that the insurance company has a financial reporting year equivalent to the calendar year (i.e. the 2017 financial year means 1.1.2017-31.12.2017 for them).

## Earned premium concept - (see accompanying picture - XXX) 
We are now in 31.12.2017, the insurer is closing his financial year and he needs to decide what profit&loss he should report for 2017. On our policy the client already paid (or at least the premium has been written / i.e. invoiced - late payments, etc. are another issue) the whole amount of 480 EUR and let's assume that during the first 2 months of the policy there were 0 EUR claims. 480 EUR is the written premium in 2017.

If the insurer only followed a cash flow approach (profit = written premium - claims) he would report a very nice profit of 480 EUR on this policy in the year 2017. This however does not make much sense because the policy had only two months for a claim to happen in 2017 and there will still be 10 months (i.e. majority of the coverage period) left during 2018 when a claim could happen and the insurer would have pay. 

To consider the 480 EUR as profit already in 2017 would be extremely optimistic so that is not how it is done. What the insurer can say is that 2 out of the 12 months which are covered are already finished so the insurer "earned" the part of the total premium corresponding to these 2 months = 2/12 * 480 EUR = 80 EUR. This is called earned premium (in other words it is spreading the premium payments across the whole coverage of the policy regardsless of payment frequency, there is also a bit of nuance in written premium vs. actually paid premium but that is already a technical detail). The remaining 400 EUR will be "earned" in 2018 so at the end of the year 2017 it is put aside for next year = a premium reserve will be created. 

On a portfolio level (which is the case of the discussed Aviva IFRS financial statements) the earned premium for a given period can be calculated as the writted premium minus the change in the premium reserve (premium reserve at the end of the period minus premium reserve at the start of the period). In the Aviva statement (Consolidated income sheet) this is the row 10 plus (written premium) and row 11 (change in premium reserve) with the result being the earned premium in row 12.

## Reinsurnace concept - Gross vs. net premium
Insurers typically want to limit their risk exposure so they cede part of their risk to reinsurers (i.e. insurance for insurers). So for agreed parts of the insurer's portfolio the claims (or their parts) are paid by the reinsurer. As payment for this the insurer cedes part of the premium it is recieving also to the reinsurer. This part is called ceded premium. The simplest type of reinsurance is quota share where for example the reinsurer pays 10% of each claim and for this he gets 10% of the premium. Reinsurance arrangments can however be much more complex.

Gross premium is the premium which the insurer recieves from it's clients before taking into account any reinsurance arrangements. Net premium is the premium that is left to the insurer after he cedes the agreed part of the premium to the reinsurer.

## Net earned premium
By combining these two things we get the
Net earned premium = Earned premium for given time period - part of earned premium ceded to reinsurer

# Question 2) What can you say about the results?
XXX

Please include everything as commits in a git repository starting from this one. Don't worry too much about making it all nice or perfect, we'll discuss it later with you. Please send us back this repository as a git bundle (`git bundle create $user-coya-bi-challenge master`) or a link to a git repository.

Good luck!

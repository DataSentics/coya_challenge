# Coya Business Intelligence challenge - Insurance P&L
One of the colleagues asked you how to read a profit-and-loss statement of an insurance company

Using the following dataset
https://www.aviva.com/media/upload/ifrs.xlsx

# Question 1) How would you explain the net earned premium figure calculation?

## Probably on an example: 
Let's take a motor insurance policy (one year coverage) which starts on 1.11.2017 and has a total premium of 480 EUR. There are different options on how to pay premium in terms of frequency = one payment at the start for the whole policy or for example quarterly or monthly but typically many clients go with one annual payment at the start of the policy. Let's assume we have a annual premium paid at the start. Also let's assume that the insurance company has a financial reporting year equivalent to the calendar year (i.e. the 2017 financial year means 1.1.2017-31.12.2017 for them).

## Earned premium concept
(see accompanying picture - earned_premium.jpg, https://github.com/DataSentics/coya_challenge/blob/master/bi_challenge_ifrs/earned_premium.jpg) 

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
One could spend a lifetime looking for interesting things within the IFRS statements, some things which are interesting on first glance (especially from the P&L):
• Aviva has not ceded much of it's business to reinsurers (only cca 7% of premium which is not that much). Aviva is one of the largest global players so the need for reinsurance is lower (Aviva can diversify very well on it's own due to it's scale and global reach). Also it's mainly life&pensions business where reinsurance plays a much smaller role then in non-life.
• The change in the premium reserve is relatively small compared to the written premium - this is consistent with the fact that Aviva is a matured player and new business is only a fraction compared to the existing portfolio. This would look very different for an insurnace start-up.
• Very high investment income - again connected to the fact that the portfolio is mainly composed of traditional life&pension products with strong investment components and exists for a long time. The reservers are very high and the incomes from the assets covering these reserves are the main potential source of profit for Aviva (they need to earn more on investments than the return which they guarantee to the policyholders).
• Becuase this is the life business it is very difficult to draw conclusions regarding the whether Aviva was actually doing well or not in the given year. The accounting profit is mostly influenced by which bonds are accounted as HTM and which AFS, how the lapse and mortality assumptions in the mathematical reserves calculations changed, etc.
• On the sheet A20 – Analysis of general insurance, one can see that GI is really less significant that the life/pensions business. Only 3,5b out of the 14b correspond to GI. The profitability of GI is very low with a combined ratio of 97% in the UK (i.e. only 3% of premium are profit). GI rather seems to play as a cross-sell instrument for the life/pensions business.
• The sheet B1 - Geog analysis is interesting as it presents the present value of new business premiums (=expected all future premium coming from new business in the given period discounted to today's prices). The life PVNBP for this period is 15b compared to 17b in the same period the year before which indicates that the growth of Aviva is declining (is was the crysis year after all).
• What's also interesting from B5 - Life pension sales is the fact that most of the PVNBP is coming from single premium contracts (paid up-front) - 8b, only 4,5b is coming from regular paid premium. This again indicates that the insurance is actually more of an investment vehicle than actual risk insurance
• Sheet B7 - New business finally gives us some insights into profitability. This is telling us that the value of new business (all expected future profits from the new business in the given period discounted to today's date) is only 141m compared to the 11,6b value of new business premiums. The ratio is in essence something like a life business equivalent of the combined ratio from non-life. The value of profits is only 1,2% of the value of premiums - i.e. extremely low. This tells us several things:
  • it's mainly investment business, there is a lot of money going through the company but it's not actually the company's, it's more like a bank fee business
  • they are not doing that well (crysis years) - probably the investments return were low at that time and hardly sufficient to cover the guaranteed returns to policyholders
  • the ration decreased from 1,7% the year before to 1,2% - it was bad the year before but it's gotten even worse
  • there is a very big difference between traditional counties (UK, France, etc.) and Higher growth markets (Poland, Asia, Other) - the newer markets are much more profitable and much less affected by the crysis (probably also less investment products and more risk products)
• From C1 – Capital management we can see that the MCEV actually increased by 0,3b - this is the best indication that the company is still actually generating some value (making money) even if the accounting result is saying other wise
• From C5 – IFRS Sensitivity analysis it can be seen that the equity (value) of the company is most sensitive to interest rates (natural because of high amount of investment products) and annuitant mortality (if people with annuities live longer - makes sense because of high amount of pension business)

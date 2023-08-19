const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "Overmint3";

describe(NAME, function () {
    async function setup() {
        const [owner, attackerWallet, w1, w2, w3, w4] = await ethers.getSigners();

        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy();

        return { victimContract, attackerWallet, w1, w2, w3, w4 };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet, w1, w2, w3, w4;
        before(async function () {
            ({ victimContract, attackerWallet, w1, w2, w3, w4 } = await loadFixture(setup));
        });

        it("conduct your attack here", async function () {
            await victimContract.connect(attackerWallet).mint();

            await victimContract.connect(w1).mint();
            await victimContract.connect(w2).mint();
            await victimContract.connect(w3).mint();
            await victimContract.connect(w4).mint();

            await victimContract.connect(w1).transferFrom(w1.address, attackerWallet.address, 2);
            await victimContract.connect(w2).transferFrom(w2.address, attackerWallet.address, 3);
            await victimContract.connect(w3).transferFrom(w3.address, attackerWallet.address, 4);
            await victimContract.connect(w4).transferFrom(w4.address, attackerWallet.address, 5);
        });

        after(async function () {
            expect(await victimContract.balanceOf(attackerWallet.address)).to.be.equal(5);
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.equal(
                1,
                "must exploit one transaction"
            );
        });
    });
});

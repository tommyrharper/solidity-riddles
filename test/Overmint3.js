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
            const AttackerFactory = await ethers.getContractFactory("Overmint3Attacker");
            await AttackerFactory.connect(attackerWallet).deploy(victimContract.address); 
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

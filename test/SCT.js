const { assert } = require("hardhat");

const GdeSS = artifacts.require("GdeSS");


contract("GdeSS", (accounts) => {
    let a = accounts;
    it("Should do some shit", async function () {
        const cont = await GdeSS.new();
        const result = await cont.deposit({from: a});
        assert.equal(result.logs[0].BensToBalance, 0);
    })
})
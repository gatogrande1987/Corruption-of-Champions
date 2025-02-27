package classes.Scenes.Combat.SpellsBlack {
import classes.GlobalFlags.kACHIEVEMENTS;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.AbstractBlackSpell;
import classes.Scenes.Combat.DamageType;
import classes.StatusEffects;

public class ArcticGaleSpell extends AbstractBlackSpell {
	public var ex:Boolean;
	
	public function ArcticGaleSpell(ex:Boolean = false) {
		super(
				ex ? "Arctic Gale (Ex)" : "Arctic Gale",
				ex ?
						"Devastate the enemy ranks with a barrage of wrath-enpowered steely ice daggers, driven by the cold northern winds."
						: "Devastate the enemy ranks with a barrage of steely ice daggers, driven by the cold northern winds.",
				TARGET_ENEMY,
				TIMING_INSTANT,
				[TAG_DAMAGING, TAG_ICE, TAG_AOE]
		);
		baseManaCost = 200;
		if (ex) baseWrathCost = 100;
		this.ex = ex;
	}
	
	override public function get buttonName():String {
		return ex ? "ArcticGale(Ex)" : "Arctic Gale";
	}
	
	override public function describeEffectVs(target:Monster):String {
		return "~" + calcDamage(target, false) + " ice damage"
	}
	
	override public function get isKnown():Boolean {
		return player.hasStatusEffect(StatusEffects.KnowsArcticGale) &&
				(!ex || player.hasPerk(PerkLib.MagesWrathEx));
	}
	
	override public function calcCooldown():int {
		return spellBlackCooldown();
	}
	
	public function calcDamage(monster:Monster, randomize:Boolean = true):Number {
		var baseDamage:Number = 2 * scalingBonusIntelligence(randomize);
		if (ex) baseDamage *= 2;
		return adjustSpellDamage(baseDamage, DamageType.ICE, CAT_SPELL_BLACK, monster);
	}
	
	override protected function doSpellEffect(display:Boolean = true):void {
		if (display) {
			outputText("You focus your power, spreading your fingers wide. The temperature drops around you, and your fingers feel almost numb as scalpel-sharp icicles form in a halo around each of your hands. The wind picks up, carrying them away, but more form in their place. With a cry, you bring your hands together in front of you, whipping the winds to a frenzy, showering [themonster] in a hailstorm of razor-sharp icicles.\n");
		}
		var damage:Number = calcDamage(monster);
		damage = critAndRepeatDamage(display, damage, DamageType.ICE);
		if (ex) awardAchievement("Edgy Caster", kACHIEVEMENTS.COMBAT_EDGY_CASTER);
		checkAchievementDamage(damage);
		combat.heroBaneProc(damage);
	}
}
}

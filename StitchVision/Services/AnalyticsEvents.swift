import Foundation

/// Lightweight event tracker per PRD Addendum F.
/// In production, replace print statements with Firebase Analytics logEvent calls.
enum StitchAnalytics {

    // MARK: - Onboarding Events (F.1)

    static func onboardingStarted() {
        track("onboarding_started", ["platform": "ios"])
    }

    static func onboardingScreenViewed(screenNumber: Int, screenName: String) {
        track("onboarding_screen_viewed", ["screen_number": screenNumber, "screen_name": screenName])
    }

    static func onboardingCraftSelected(_ craftType: String) {
        track("onboarding_craft_selected", ["craft_type": craftType])
    }

    static func onboardingSkillSelected(_ skillLevel: String) {
        track("onboarding_skill_selected", ["skill_level": skillLevel])
    }

    static func calibrationStarted(craftType: String) {
        track("calibration_started", ["craft_type": craftType])
    }

    static func calibrationSucceeded(durationSeconds: Int, craftType: String) {
        track("calibration_succeeded", ["duration_seconds": durationSeconds, "craft_type": craftType])
    }

    static func calibrationFailed(attempts: Int, craftType: String) {
        track("calibration_failed", ["attempts": attempts, "craft_type": craftType])
    }

    static func onboardingCompleted(isPro: Bool, completedCalibration: Bool) {
        track("onboarding_completed", ["is_pro": isPro, "completed_calibration": completedCalibration])
    }

    // MARK: - Core Feature Events (F.2)

    static func projectCreated(source: String, craftType: String, isPro: Bool) {
        track("project_created", ["source": source, "craft_type": craftType, "is_pro": isPro])
    }

    static func rowCountedVision(projectId: Int?, currentRow: Int, craftType: String) {
        track("row_counted_vision", ["project_id": projectId ?? 0, "current_row": currentRow, "craft_type": craftType])
    }

    static func rowCountedManual(projectId: Int?, currentRow: Int) {
        track("row_counted_manual", ["project_id": projectId ?? 0, "current_row": currentRow])
    }

    static func rowAdjusted(projectId: Int?, currentRow: Int) {
        track("row_adjusted", ["project_id": projectId ?? 0, "current_row": currentRow, "delta": -1])
    }

    static func batterySaverToggled(newState: Bool, projectId: Int?) {
        track("battery_saver_toggled", ["new_state": newState ? "on" : "off", "project_id": projectId ?? 0])
    }

    static func stitchDoctorUsed(isPro: Bool, remainingUses: Int, resultType: String) {
        track("stitch_doctor_used", ["is_pro": isPro, "remaining_uses": remainingUses, "result_type": resultType])
    }

    static func stitchDoctorPaywall(usesConsumed: Int) {
        track("stitch_doctor_paywall", ["uses_consumed": usesConsumed])
    }

    static func patternUploaded(pageCount: Int, isPro: Bool, result: String) {
        track("pattern_uploaded", ["page_count": pageCount, "is_pro": isPro, "result": result])
    }

    static func projectFinished(totalRows: Int, daysActive: Int, craftType: String) {
        track("project_finished", ["total_rows": totalRows, "days_active": daysActive, "craft_type": craftType])
    }

    // MARK: - StitchBot Events (F.3)

    static func stitchbotSessionStarted(isPro: Bool, questionsRemaining: Int?) {
        track("stitchbot_session_started", ["is_pro": isPro, "questions_remaining": questionsRemaining ?? -1])
    }

    static func stitchbotQuestionAsked(isPro: Bool, sessionTurn: Int, contextProvided: Bool) {
        track("stitchbot_question_asked", ["is_pro": isPro, "session_turn": sessionTurn, "context_provided": contextProvided])
    }

    static func stitchbotLimitHit() {
        track("stitchbot_limit_hit", ["source": "stitchbot"])
    }

    // MARK: - Retention Events (F.4)

    static func paywallViewed(source: String, isRepeat: Bool) {
        track("paywall_viewed", ["source": source, "is_repeat": isRepeat])
    }

    static func subscriptionStarted(plan: String, price: Double, source: String) {
        track("subscription_started", ["plan": plan, "price": price, "source": source])
    }

    static func streakAchieved(streakDays: Int) {
        track("streak_achieved", ["streak_days": streakDays])
    }

    static func appOpened(isPro: Bool, daysSinceInstall: Int, currentStreak: Int) {
        track("app_opened", ["is_pro": isPro, "days_since_install": daysSinceInstall, "current_streak": currentStreak])
    }

    static func glossaryOpened(source: String) {
        track("glossary_opened", ["source": source])
    }

    // MARK: - Private

    private static func track(_ eventName: String, _ params: [String: Any] = [:]) {
        #if DEBUG
        print("[Analytics] \(eventName) \(params)")
        #else
        // TODO: Replace with Firebase Analytics
        // Analytics.logEvent(eventName, parameters: params)
        #endif
    }
}

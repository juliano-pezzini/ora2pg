-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS exame_lab_result_item_hl7 ON exame_lab_result_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_exame_lab_result_item_hl7() RETURNS trigger AS $BODY$
declare
ds_sep_bv_w		varchar(100);
cd_pessoa_fisica_w	varchar(10);
ds_param_integ_hl7_w	varchar(4000);
nr_prescricao_w		bigint;

ie_valido_dixtal_w	varchar(1);
ie_valido_dixtal_ep12_w	varchar(1);

sql_errm_w		varchar(255);
qt_reg_w		bigint;
nr_atendimento_w	bigint;
pragma autonomous_transaction;
BEGIN
  BEGIN
ds_sep_bv_w := obter_separador_bv;
/*
if	(:old.dt_aprovacao is null) and
	(:new.dt_aprovacao is not null) then
	begin
	begin
	select	pm.cd_pessoa_fisica,
		nvl(pm.nr_atendimento,0),
		nvl(obter_atepacu_paciente(nvl(pm.nr_atendimento,0),'IA'),0)
	into	cd_pessoa_fisica_w,
		nr_atendimento_w,
		nr_seq_interno_w
	from	prescr_medica pm,
		prescr_procedimento pp,
		exame_lab_resultado elr,
		exame_lab_result_item elri
	where	pm.nr_prescricao = pp.nr_prescricao
	and	pp.nr_prescricao = elr.nr_prescricao
	and	pp.nr_sequencia = elri.nr_seq_prescr
	and	elri.nr_seq_resultado = elr.nr_seq_resultado
	and	elr.nr_seq_resultado = :new.nr_seq_resultado
	and	elri.nr_sequencia = :new.nr_sequencia;

	ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_w || ds_sep_bv_w ||
				'nr_atendimento=' || nr_atendimento_w || ds_sep_bv_w ||
				'nr_seq_interno=' || nr_seq_interno_w || ds_sep_bv_w ||
				'nr_seq_resultado=' || :new.nr_seq_resultado || ds_sep_bv_w ||
				'nr_seq_result_item=' || :new.nr_sequencia || ds_sep_bv_w;
	gravar_agend_integracao(24, ds_param_integ_hl7_w);
	exception
	when others then
		ds_param_integ_hl7_w := '';
	end;
	end;
end if;
*/
if (OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) then

	BEGIN

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_valido_dixtal_w
	from	lab_exame_equip a,
		equipamento_lab b
	where	a.cd_equipamento = b.cd_equipamento
	and	b.ds_sigla = 'DXQT'
	--and	a.cd_equipamento = 24 --Dixtal (QuaTi)
	and	a.nr_seq_exame = NEW.nr_seq_exame;

	if (ie_valido_dixtal_w = 'S') then

		select	max(b.cd_pessoa_fisica),
			max(b.nr_prescricao)
		into STRICT	cd_pessoa_fisica_w,
			nr_prescricao_w
		from  	exame_lab_resultado a,
			prescr_medica b
		where	a.nr_Seq_resultado = NEW.nr_seq_resultado
		and	a.nr_prescricao = b.nr_prescricao;

		ds_param_integ_hl7_w :=	'CD_PESSOA_FISICA=' || cd_pessoa_fisica_w || ds_sep_bv_w ||
					'NR_PRESCRICAO=' || nr_prescricao_w || ds_sep_bv_w ||
					'NR_SEQ_RESULTADO=' || NEW.nr_seq_resultado || ds_sep_bv_w ||
					'NR_SEQ_RESULT_ITEM=' || NEW.nr_sequencia || ds_sep_bv_w ||
					'NR_SEQ_PRESCR=' || NEW.nr_seq_prescr || ds_sep_bv_w;

		CALL gravar_agend_integracao(189, ds_param_integ_hl7_w);

	end if;

	exception
	when others then
		ds_param_integ_hl7_w := '';
	end;

	BEGIN
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_valido_dixtal_ep12_w
	from	lab_exame_equip a,
		equipamento_lab b
	where	a.cd_equipamento = b.cd_equipamento
	and	b.ds_sigla = 'DIXEP12'
	--and	a.cd_equipamento = 24 --Dixtal (EP12)
	and	a.nr_seq_exame = NEW.nr_seq_exame;

	if (ie_valido_dixtal_ep12_w = 'S') then

		select	max(b.cd_pessoa_fisica),
			max(b.nr_prescricao)
		into STRICT	cd_pessoa_fisica_w,
			nr_prescricao_w
		from  	exame_lab_resultado a,
			prescr_medica b
		where	a.nr_Seq_resultado = NEW.nr_seq_resultado
		and	a.nr_prescricao = b.nr_prescricao;

		ds_param_integ_hl7_w :=	'CD_PESSOA_FISICA=' || cd_pessoa_fisica_w || ds_sep_bv_w ||
					'NR_PRESCRICAO=' || nr_prescricao_w || ds_sep_bv_w ||
					'NR_SEQ_RESULTADO=' || NEW.nr_seq_resultado || ds_sep_bv_w ||
					'NR_SEQ_RESULT_ITEM=' || NEW.nr_sequencia || ds_sep_bv_w ||
					'NR_SEQ_PRESCR=' || NEW.nr_seq_prescr || ds_sep_bv_w;

		CALL gravar_agend_integracao(217, ds_param_integ_hl7_w);

	end if;

	exception
	when others then
		ds_param_integ_hl7_w := '';
	end;


	BEGIN


	select count(*)
	into STRICT	qt_reg_w
	from	PHILIPS_INTELLIVUE_LAB;

	if (qt_reg_w > 0) then

		select count(*)
		into STRICT	qt_reg_w
		from	PHILIPS_INTELLIVUE_LAB x
		where	exists (	SELECT	1
							from	exame_lab_result_item a
							where	a.nr_seq_resultado = NEW.nr_seq_resultado
							and		x.nr_seq_exame = a.nr_seq_exame);


		if (qt_reg_w	> 0) then
			BEGIN

			select	max(b.cd_pessoa_fisica),
					max(b.nr_atendimento)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w
			from  	exame_lab_resultado a,
					prescr_medica b
			where	a.nr_Seq_resultado = NEW.nr_seq_resultado
			and		a.nr_prescricao = b.nr_prescricao;


			if (nr_atendimento_w is not null) then
				ds_param_integ_hl7_w := 'nr_atendimento=' || nr_atendimento_w || ds_sep_bv_w ||
										'NR_SEQ_RESULTADO=' || NEW.nr_seq_resultado|| ds_sep_bv_w ||
					'cd_pessoa_fisica=' || cd_pessoa_fisica_w|| ds_sep_bv_w;

				CALL gravar_agend_integracao(446, ds_param_integ_hl7_w);
			end if;

			end;
		end if;

	end if;

	commit;

	exception
	when others then
		ds_param_integ_hl7_w := '';
	end;





end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_exame_lab_result_item_hl7() FROM PUBLIC;

CREATE TRIGGER exame_lab_result_item_hl7
	AFTER INSERT OR UPDATE ON exame_lab_result_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_exame_lab_result_item_hl7();


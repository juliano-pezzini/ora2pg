-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_des_requisito_before ON des_requisito CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_des_requisito_before() RETURNS trigger AS $BODY$
declare
	ie_html5_w	varchar(1);
	nr_seq_pr_w	reg_product_requirement.nr_sequencia%type;
BEGIN
	if (OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) then
		select
			case
				when ie_html5           = 'S'
				or (coalesce(ie_java, 'N')   = 'N'
				and coalesce(ie_delphi, 'N') = 'N')
				then 'S'
				else ie_html5
			end
		into STRICT ie_html5_w
		from proj_projeto
		where nr_sequencia = NEW.nr_seq_projeto;

		if	ie_html5_w = 'S' then

			select	max(pr.nr_sequencia)
			into STRICT	nr_seq_pr_w
			from	des_requisito_item ri
			left join reg_caso_teste tc on tc.nr_seq_product = ri.nr_seq_pr
			join reg_product_requirement pr on pr.nr_sequencia = ri.nr_seq_pr
			where	ri.nr_seq_requisito	= NEW.nr_sequencia
			and	tc.nr_sequencia is null;

			if	nr_seq_pr_w is not null then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(997073);
			end if;
		end if;
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_des_requisito_before() FROM PUBLIC;

CREATE TRIGGER reg_des_requisito_before
	BEFORE UPDATE ON des_requisito FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_des_requisito_before();

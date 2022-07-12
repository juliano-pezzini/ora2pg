-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_customer_req_update ON reg_customer_requirement CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_customer_req_update() RETURNS trigger AS $BODY$
declare

  qt_product_requirements_w bigint;

  nr_seq_ap_area_w reg_area_customer.nr_seq_apresentacao%type;

  nr_seq_ap_feature_w reg_features_customer.nr_seq_apresentacao%type;

  nr_seq_intencao_uso_w bigint;

  nr_seq_urs_w bigint;

  ds_prefixo_w varchar(15);

  nr_sequencia_w varchar(15);

BEGIN

	if (wheb_usuario_pck.get_ie_executar_trigger = 'N') then
		goto Final;
	end if;

  select count(1)

    into STRICT qt_product_requirements_w

    from reg_product_requirement

   where nr_customer_requirement = NEW.nr_sequencia;

  if (NEW.cd_crs_id is null) or (NEW.cd_crs_id is not null and qt_product_requirements_w = 0) then

    if NEW.nr_seq_features is not null then

      select ac.nr_seq_apresentacao,

             fc.nr_seq_apresentacao,

             iu.nr_sequencia,

             iu.ds_prefixo

        into STRICT nr_seq_ap_area_w,

             nr_seq_ap_feature_w,

             nr_seq_intencao_uso_w,

             ds_prefixo_w

        from reg_area_customer ac,

             reg_features_customer fc,

             reg_intencao_uso iu

       where ac.nr_sequencia = fc.nr_seq_area_customer

         and ac.nr_seq_intencao_uso = iu.nr_sequencia

         and fc.nr_sequencia = NEW.nr_seq_features;

    elsif NEW.nr_seq_intencao_uso is not null then

      select iu.nr_sequencia,

             iu.ds_prefixo

        into STRICT nr_seq_intencao_uso_w,

             ds_prefixo_w

        from reg_intencao_uso iu

       where iu.nr_sequencia = NEW.nr_seq_intencao_uso;

    end if;

    -- Se a intencao de uso for do Tasy, manter nomeclatura do id




    if nr_seq_intencao_uso_w = 2 then

      NEW.cd_crs_id := 'A_0_' || nr_seq_ap_area_w || '.' ||
                        nr_seq_ap_feature_w || '.' ||
                        NEW.nr_seq_apresentacao;

    elsif TG_OP = 'INSERT' then

      select max(a.nr_sequencia)
        into STRICT nr_seq_urs_w
        from reg_customer_requirement a
       where a.nr_seq_intencao_uso = coalesce(NEW.nr_seq_intencao_uso, nr_seq_intencao_uso_w);


      if (nr_seq_urs_w is not null) then

        select coalesce(obter_somente_numero(cd_crs_id), 0) + 1
          into STRICT nr_sequencia_w
          from reg_customer_requirement
         where nr_sequencia = nr_seq_urs_w;

      end if;

      NEW.cd_crs_id := coalesce(ds_prefixo_w, nr_seq_intencao_uso_w) || '_URS_' ||
                        coalesce(nr_sequencia_w, '1');

    end if;

  end if;

	<<Final>>
    
	if (nr_seq_intencao_uso_w is not null) then
		NEW.nr_seq_intencao_uso := nr_seq_intencao_uso_w;
	end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_customer_req_update() FROM PUBLIC;

CREATE TRIGGER reg_customer_req_update
	BEFORE INSERT OR UPDATE ON reg_customer_requirement FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_customer_req_update();


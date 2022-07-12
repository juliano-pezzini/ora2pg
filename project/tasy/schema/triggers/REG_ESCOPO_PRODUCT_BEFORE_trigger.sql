-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_escopo_product_before ON reg_escopo_product_req CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_escopo_product_before() RETURNS trigger AS $BODY$
declare

  qt_test_case_scope_w bigint;

  c_test_cases CURSOR FOR
    SELECT ct.nr_sequencia
      from reg_caso_teste ct
     where ct.nr_seq_product = NEW.nr_seq_product_req
       and not exists (SELECT 1
              from reg_escopo_caso_teste
             where nr_seq_caso_teste = ct.nr_sequencia
               and nr_seq_escopo = NEW.nr_seq_escopo);

BEGIN

  if TG_OP = 'UPDATE' then

    if (OLD.IE_STATUS_CCB = 'AI' and NEW.IE_STATUS_CCB = 'A') then
    
      for r_c_test_cases in c_test_cases loop
      
        insert into reg_escopo_caso_teste(nr_sequencia,
           dt_atualizacao,
           nm_usuario,
           dt_atualizacao_nrec,
           nm_usuario_nrec,
           nr_seq_escopo,
           nr_seq_caso_teste)
        values (nextval('reg_escopo_caso_teste_seq'),
           LOCALTIMESTAMP,
           NEW.nm_usuario,
           LOCALTIMESTAMP,
           NEW.nm_usuario,
           NEW.nr_seq_escopo,
           r_c_test_cases.nr_sequencia);

      end loop;

    end if;

  elsif TG_OP = 'DELETE' then
  
    select count(1)
      into STRICT qt_test_case_scope_w
      from reg_caso_teste ct, reg_escopo_caso_teste ect
     where ct.nr_sequencia = ect.nr_seq_caso_teste
       and ct.nr_seq_product = OLD.nr_seq_product_req
       and ect.nr_seq_escopo = OLD.nr_seq_escopo;

    if (qt_test_case_scope_w > 0) then
      wheb_mensagem_pck.exibir_mensagem_abort(1016418); -- Este escopo ja esta incluso nos casos de teste deste requisito de produto. A exclusao deste deve ser verificada com o time de Verificacao.
    end if;

  end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_escopo_product_before() FROM PUBLIC;

CREATE TRIGGER reg_escopo_product_before
	BEFORE UPDATE OR DELETE ON reg_escopo_product_req FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_escopo_product_before();

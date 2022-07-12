-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS relatorio_parametro_atual ON relatorio_parametro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_relatorio_parametro_atual() RETURNS trigger AS $BODY$
DECLARE

    ds_module_w        varchar(48);
    nr_seq_log_w       log_atualizacao_erro.nr_seq_log%TYPE;
    ds_erro_w          log_atualizacao_erro.ds_erro%TYPE;
    ds_identificacao_w log_tasy.ds_log%type;
    ds_comando_w       Log_Atualizacao_Erro.ds_comando%TYPE;
BEGIN
  BEGIN
	IF (WHEB_USUARIO_PCK.GET_IE_EXECUTAR_TRIGGER = 'N')THEN
		IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

	END IF;

    BEGIN
	
        ds_comando_w := 'UPDATE RELATORIO ' ||
                        '   SET IE_GERAR_RELATORIO = ''S'',' ||
                        '		DT_LAST_MODIFICATION = SYSDATE, ' ||
                        '		DT_ATUALIZACAO = SYSDATE, ' ||
                        '		NM_USUARIO = :1' ||
                        ' WHERE NR_SEQUENCIA = :2';
        EXECUTE ds_comando_w USING coalesce(NEW.NM_USUARIO, OLD.NM_USUARIO), coalesce(NEW.NR_SEQ_RELATORIO, OLD.NR_SEQ_RELATORIO);
		
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
			
                ds_erro_w := SQLERRM(SQLSTATE);
                CALL tratar_erro_banco(ds_erro_w);		
                ds_module_w := wheb_usuario_pck.get_ds_form;
		
                IF (position('CORSIS_FO_NR_SEQ = ' in ds_module_w) >  0 ) THEN
                    nr_seq_log_w := substr(ds_module_w, 18, 10);
                    CALL gravar_log_atualizacao_erro(nr_seq_log_w, ds_comando_w, ds_erro_w, substr(ds_identificacao_w, 1, 15));
                ELSIF (wheb_usuario_pck.get_gravar_log_tasy = 'S') then
                    INSERT INTO log_tasy(dt_atualizacao, nm_usuario, cd_log, ds_log) VALUES (LOCALTIMESTAMP, 'Erro', 666,  ds_identificacao_w || '-> ' || ds_erro_w);
                END IF;
				
            END;
    END;

  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_relatorio_parametro_atual() FROM PUBLIC;

CREATE TRIGGER relatorio_parametro_atual
	BEFORE INSERT OR UPDATE OR DELETE ON relatorio_parametro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_relatorio_parametro_atual();


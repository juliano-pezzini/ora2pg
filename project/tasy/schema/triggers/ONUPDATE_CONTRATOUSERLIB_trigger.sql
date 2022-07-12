-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS onupdate_contratouserlib ON contrato_usuario_lib CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_onupdate_contratouserlib() RETURNS trigger AS $BODY$
DECLARE

nr_sequencia_w        contrato_historico.nr_sequencia%type;
ds_historico_w        contrato_historico.ds_historico%type;
ds_titulo_w           contrato_historico.ds_titulo%type;
nm_usuario_w          contrato_historico.nm_usuario%type := NEW.nm_usuario;
nr_seq_contrato_w     contrato_historico.nr_seq_contrato%type;
nm_usuario_comp_old_w varchar(60);
nm_usuario_comp_w     varchar(60);
ds_setor_old_w        varchar(60);
ds_setor_w            varchar(60);
ds_perfil_old_w       varchar(60);
ds_perfil_w           varchar(60);

BEGIN

if (NEW.cd_perfil <> OLD.cd_perfil) then
    BEGIN

       ds_perfil_old_w := substr(obter_desc_perfil(OLD.cd_perfil),1,255);
       ds_perfil_w := substr(obter_desc_perfil(NEW.cd_perfil),1,255);

       select nextval('contrato_historico_seq')
       into STRICT nr_sequencia_w
;

       ds_titulo_w := wheb_mensagem_pck.get_texto(1095623);
       ds_historico_w := substr(wheb_mensagem_pck.get_texto(1095449) || ' ' || ds_perfil_old_w || chr(10) || chr(13)
                        || wheb_mensagem_pck.get_texto(1095450) || ' ' || ds_perfil_w,1,1200);
       nr_seq_contrato_w    := NEW.nr_seq_contrato;
       insert into contrato_historico(nr_sequencia,
                                      nr_seq_contrato,
                                      dt_historico,
                                      ds_historico,
                                      dt_atualizacao,
                                      nm_usuario,
                                      ds_titulo,
                                      dt_liberacao,
                                      nm_usuario_lib,
                                      ie_efetivado)
       values (nr_sequencia_w,
              nr_seq_contrato_w,
              LOCALTIMESTAMP,
              ds_historico_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
              ds_titulo_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
             'N');
    end;
end if;
if (NEW.cd_setor <> OLD.cd_setor) then
    BEGIN

       ds_setor_old_w := substr(obter_ds_descricao_setor(OLD.cd_setor),1,255);
       ds_setor_w := substr(obter_ds_descricao_setor(NEW.cd_setor),1,255);

       select nextval('contrato_historico_seq')
       into STRICT nr_sequencia_w
;

       ds_titulo_w := wheb_mensagem_pck.get_texto(1095622);
       ds_historico_w := substr(wheb_mensagem_pck.get_texto(1095449) || ' ' || ds_setor_old_w || chr(10) || chr(13)
                        || wheb_mensagem_pck.get_texto(1095450) || ' ' || ds_setor_w,1,1200);
       nr_seq_contrato_w    := NEW.nr_seq_contrato;
       insert into contrato_historico(nr_sequencia,
                                      nr_seq_contrato,
                                      dt_historico,
                                      ds_historico,
                                      dt_atualizacao,
                                      nm_usuario,
                                      ds_titulo,
                                      dt_liberacao,
                                      nm_usuario_lib,
                                      ie_efetivado)
       values (nr_sequencia_w,
              nr_seq_contrato_w,
              LOCALTIMESTAMP,
              ds_historico_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
              ds_titulo_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
             'N');
    end;
end if;
if (NEW.nm_usuario_lib <> OLD.nm_usuario_lib) then
    BEGIN

       nm_usuario_comp_old_w := substr(obter_nome_usuario(OLD.nm_usuario_lib),1,100);
       nm_usuario_comp_w :=  substr(obter_nome_usuario(NEW.nm_usuario_lib),1,100);

       select nextval('contrato_historico_seq')
       into STRICT nr_sequencia_w
;

       ds_titulo_w := wheb_mensagem_pck.get_texto(1095621);
       ds_historico_w := substr(wheb_mensagem_pck.get_texto(1095449) || ' ' || OLD.nm_usuario_lib || ' - ' || nm_usuario_comp_old_w || chr(10) || chr(13)
                        || wheb_mensagem_pck.get_texto(1095450) || ' ' || NEW.nm_usuario_lib || ' - ' || nm_usuario_comp_w,1,1200);
       nr_seq_contrato_w    := NEW.nr_seq_contrato;
       insert into contrato_historico(nr_sequencia,
                                      nr_seq_contrato,
                                      dt_historico,
                                      ds_historico,
                                      dt_atualizacao,
                                      nm_usuario,
                                      ds_titulo,
                                      dt_liberacao,
                                      nm_usuario_lib,
                                      ie_efetivado)
       values (nr_sequencia_w,
              nr_seq_contrato_w,
              LOCALTIMESTAMP,
              ds_historico_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
              ds_titulo_w,
              LOCALTIMESTAMP,
              nm_usuario_w,
             'N');
    end;
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_onupdate_contratouserlib() FROM PUBLIC;

CREATE TRIGGER onupdate_contratouserlib
	AFTER UPDATE ON contrato_usuario_lib FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_onupdate_contratouserlib();


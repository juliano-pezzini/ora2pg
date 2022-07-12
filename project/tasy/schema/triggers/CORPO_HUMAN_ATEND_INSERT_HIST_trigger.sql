-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS corpo_human_atend_insert_hist ON corpo_humano_atend CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_corpo_human_atend_insert_hist() RETURNS trigger AS $BODY$
declare

nr_idade_menor_w			bigint;
nr_subt_idade_w				bigint;
ie_sexo_w 					pessoa_fisica.ie_sexo%type;
ie_tipo_w 					corpo_humano_config.ie_tipo%type;
qt_idade_ano_max_w			corpo_humano_repres_idade.qt_idade_ano_max%type;
nr_seq_repres_idade_w 		corpo_humano_repres_idade.nr_seq_repres_idade%type;
nr_seq_repres_corporal_w 	corpo_humano_rep_corporal.nr_seq_rep_corporal%type;
nr_repres_idade_w			corpo_humano_repres_idade.nr_seq_repres_idade%type;

c01 CURSOR FOR
SELECT nr_seq_repres_idade,
		qt_idade_ano_max
from corpo_humano_repres_idade
where ie_situacao = 'A'
order by qt_idade_ano_max;

BEGIN
  nr_idade_menor_w := 99999;
  if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

    select max(nr_seq_repres_idade)
    into STRICT nr_seq_repres_idade_w
    from CORPO_HUMANO_REPRES_IDADE
    where ie_situacao = 'A'
    and NEW.qt_idade between qt_idade_ano_min and qt_idade_ano_max;
	
	if ( nr_seq_repres_idade_w is null and NEW.qt_idade = 0 ) then
		nr_seq_repres_idade_w := null;

	elsif ( nr_seq_repres_idade_w is null ) then
		open c01;
		loop
		fetch C01 into	
			nr_repres_idade_w,
			qt_idade_ano_max_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			BEGIN
				nr_subt_idade_w := ABS(qt_idade_ano_max_w - NEW.qt_idade);
				if ( nr_subt_idade_w < nr_idade_menor_w) then
					nr_idade_menor_w  := nr_subt_idade_w;
					nr_seq_repres_idade_w := nr_repres_idade_w;
				end if;
			end;
		end loop;
		close c01;
	end if;
	
    select nr_seq_rep_corporal
    into STRICT nr_seq_repres_corporal_w
    from CORPO_HUMANO_REP_CORPORAL
    where ie_situacao = 'A'
    and NEW.qt_icm between qt_icm_min and qt_icm_max;

    select ie_tipo
    into STRICT ie_tipo_w
    from corpo_humano_config 
    where nr_seq_config = NEW.nr_seq_config;

    if (TG_OP = 'INSERT') then

      select IE_SEXO
      into STRICT ie_sexo_w 
      from pessoa_fisica 
      where cd_pessoa_fisica = NEW.cd_pessoa_fisica;


      insert into CORPO_HUMANO_ATEND_REPRES(
        NR_SEQ_REP_CORPORAL,
        NR_SEQ_ATEND_REPRES,
        NR_SEQ_REPRES_IDADE,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC,
        IE_SITUACAO,
        IE_SEXO,
        NR_SEQ_ATEND,
        IE_TIPO
      ) values (
        nr_seq_repres_corporal_w, -- NR_SEQ_REP_CORPORAL,
        nextval('corpo_humano_atend_repres_seq'), -- NR_SEQ_ATEND_REPRES, 
        nr_seq_repres_idade_w, -- NR_SEQ_REPRES_IDADE,
        LOCALTIMESTAMP,  -- DT_ATUALIZACAO,
        NEW.nm_usuario, -- NM_USUARIO,
        LOCALTIMESTAMP, -- DT_ATUALIZACAO_NREC,
        NEW.nm_usuario, -- NM_USUARIO_NREC,
        'A', -- IE_SITUACAO,
        ie_sexo_w, -- IE_SEXO,
        NEW.NR_SEQ_ATEND,
        ie_tipo_w --IE_TIPO
      );


    elsif (TG_OP = 'UPDATE') then

      if (NEW.dt_liberacao is not null) then
        update CORPO_HUMANO_ATEND_REPRES
        set dt_liberacao = LOCALTIMESTAMP
        where NR_SEQ_ATEND = NEW.NR_SEQ_ATEND;
      end if;

      update CORPO_HUMANO_ATEND_REPRES
      set NR_SEQ_REP_CORPORAL = nr_seq_repres_corporal_w,
      NR_SEQ_REPRES_IDADE = nr_seq_repres_idade_w
      where NR_SEQ_ATEND = NEW.NR_SEQ_ATEND;


    end if;

  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_corpo_human_atend_insert_hist() FROM PUBLIC;

CREATE TRIGGER corpo_human_atend_insert_hist
	AFTER INSERT OR UPDATE ON corpo_humano_atend FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_corpo_human_atend_insert_hist();


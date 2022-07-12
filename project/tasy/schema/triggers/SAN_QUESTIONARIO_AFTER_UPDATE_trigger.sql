-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_questionario_after_update ON san_questionario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_questionario_after_update() RETURNS trigger AS $BODY$
declare
 
dt_liberacao_w		san_doacao_impedimento.dt_liberacao%type;
ie_novo_impedimento_w	varchar(1);
ie_definitivo_w		varchar(1);
pragma autonomous_transaction;
 
BEGIN 
 
select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END  
into STRICT	ie_novo_impedimento_w 
from	san_doacao_impedimento 
where	nr_seq_doacao = NEW.nr_seq_doacao 
and	nr_seq_impedimento = NEW.nr_seq_impedimento;
 
if (NEW.ie_impede_doacao = 'S') then 
 
	select 	max(ie_definitivo) 
	into STRICT 	ie_definitivo_w 
	from 	san_impedimento 
	where 	nr_sequencia = NEW.nr_seq_impedimento;
		 
	if (NEW.dt_ocorrencia is not null) then 
    select 	trunc(NEW.dt_ocorrencia + nr_dias_inaptidao) 
		into STRICT 	dt_liberacao_w 
		from 	san_impedimento 
		where 	nr_sequencia = NEW.nr_seq_impedimento;
	end if;
   
	if (ie_novo_impedimento_w = 'S') then 
	 
		insert	into san_doacao_impedimento(nr_seq_doacao, 
			nr_seq_impedimento, 
			dt_atualizacao, 
			nm_usuario, 
			ds_observacao, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			dt_ocorrencia, 
			ds_justificativa, 
			cd_pessoa_fisica, 
			ie_definitivo, 
			dt_liberacao) 
		values (NEW.nr_seq_doacao, 
			NEW.nr_seq_impedimento, 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			NEW.ds_observacao, 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			NEW.dt_ocorrencia, 
			NEW.ds_justificativa, 
			san_obter_doador(NEW.nr_seq_doacao, 'C'), 
			CASE WHEN ie_definitivo_w='I' THEN  'N'  ELSE CASE WHEN dt_liberacao_w IS NULL THEN 'S'  ELSE 'N' END  END , 
			dt_liberacao_w);
		 
	else 
	 
		update san_doacao_impedimento 
		set	dt_atualizacao = LOCALTIMESTAMP, 
			nm_usuario = NEW.nm_usuario, 
			ds_observacao = NEW.ds_observacao, 
			dt_ocorrencia = NEW.dt_ocorrencia, 
			ds_justificativa = NEW.ds_justificativa, 
			ie_definitivo = CASE WHEN ie_definitivo_w='I' THEN  'N'  ELSE CASE WHEN dt_liberacao_w = NULL THEN 'S'  ELSE 'N' END  END , 
			dt_liberacao = dt_liberacao_w 
		where	nr_seq_doacao = NEW.nr_seq_doacao 
		and	nr_seq_impedimento = NEW.nr_seq_impedimento;
		 
	end if;
	 
	commit;
 
elsif (ie_novo_impedimento_w = 'N') then 
 
	delete 	FROM san_doacao_impedimento 
	where	nr_seq_doacao = NEW.nr_seq_doacao 
	and	nr_seq_impedimento = NEW.nr_seq_impedimento;
	 
	commit;
	 
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_questionario_after_update() FROM PUBLIC;

CREATE TRIGGER san_questionario_after_update
	AFTER UPDATE ON san_questionario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_questionario_after_update();


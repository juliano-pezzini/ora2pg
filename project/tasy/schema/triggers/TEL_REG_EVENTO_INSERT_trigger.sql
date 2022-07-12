-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tel_reg_evento_insert ON tel_reg_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tel_reg_evento_insert() RETURNS trigger AS $BODY$
declare
nr_seq_evento_w	bigint;
nr_seq_interno_w	bigint;
ds_erro_w		varchar(255);
cd_unidade_compl_w	varchar(10);

c01 CURSOR FOR
	SELECT	nr_seq_interno,
			cd_unidade_compl
	from	unidade_atendimento
	where	nr_ramal	= NEW.nr_ramal
	order by 1 desc;

BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_evento_w
from	tel_evento
where	cd_evento	= NEW.cd_evento;

if (nr_seq_evento_w is not null) then
	NEW.nr_seq_evento	:= nr_seq_evento_w;
	select	nr_seq_acao
	into STRICT	NEW.nr_seq_acao
	from	tel_evento
	where	nr_sequencia	= nr_seq_evento_w;
end if;

NEW.ds_erro		:= wheb_mensagem_pck.get_texto(792020);

if (NEW.nm_usuario is null) then
	NEW.nm_usuario := wheb_mensagem_pck.get_texto(792021);
end if;

if (NEW.nr_seq_acao is not null) and (NEW.nr_seq_acao in (2, 4, 5, 6, 9, 13, 14, 15)) then

	open c01;
	loop
	fetch c01 into	nr_seq_interno_w,
					cd_unidade_compl_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	if (obter_se_somente_numero(cd_unidade_compl_w) = 'S') then
		if	((position('-> 1' in NEW.ds_observacao) > 0) and (mod(somente_numero(cd_unidade_compl_w),2) = 1)) or
			((position('-> 2' in NEW.ds_observacao) > 0) and (mod(somente_numero(cd_unidade_compl_w),2) = 0)) then
			exit;
		end if;
	end if;
	end loop;
	close c01;

	if (nr_seq_interno_w is null) and (NEW.cd_setor_atendimento is null) and (NEW.cd_unidade_basica is not null) and (NEW.cd_unidade_compl is not null) then
		select	min(cd_setor_atendimento),
				min(nr_seq_interno)
		into STRICT	NEW.cd_setor_atendimento,
				nr_seq_interno_w
		from	unidade_atendimento
		where	cd_unidade_basica = NEW.cd_unidade_basica
		and		cd_unidade_compl  = NEW.cd_unidade_compl;
	end if;

	if (nr_seq_interno_w is not null) then
		select 	cd_setor_atendimento,
				cd_unidade_basica,
				cd_unidade_compl
		into STRICT	NEW.cd_setor_atendimento,
				NEW.cd_unidade_basica,
				NEW.cd_unidade_compl
		from	unidade_atendimento
		where	nr_seq_interno	= nr_seq_interno_w;

		ds_erro_w := Atualizar_Acao_tasy(nr_seq_interno_w, NEW.nr_seq_acao, coalesce(NEW.nm_usuario, wheb_mensagem_pck.get_texto(792021)), ds_erro_w);

		NEW.ds_erro		:= ds_erro_w;
	else
		NEW.ds_erro		:= wheb_mensagem_pck.get_texto(792022);

	end if;
else
	NEW.ds_erro		:= wheb_mensagem_pck.get_texto(792027);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tel_reg_evento_insert() FROM PUBLIC;

CREATE TRIGGER tel_reg_evento_insert
	BEFORE INSERT ON tel_reg_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tel_reg_evento_insert();

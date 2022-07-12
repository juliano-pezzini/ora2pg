-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS checkup_diag_pac_orient_insert ON checkup_diag_pac_orient CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_checkup_diag_pac_orient_insert() RETURNS trigger AS $BODY$
DECLARE

cd_pessoa_fisica_w	varchar(10);
nr_atendimento_w	bigint;
nr_seq_orientacao_w	bigint;
nr_seq_apres_w		integer;
nr_seq_orient_w		bigint;
ds_orientacao_w		varchar(2000);
nr_seq_diag_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_seq_orientacao,
		b.ds_orientacao,
		b.nr_seq_apresent
	from	checkup_tipo_orientacao b,
		checkup_diag_orient a
	where	a.nr_seq_diag		= nr_seq_diag_w
	and	a.nr_seq_orientacao	= b.nr_sequencia
	and	not exists (	SELECT	1
				from	checkup_orientacao c
				where	c.nr_seq_orientacao	= a.nr_seq_orientacao
				and	c.nr_seq_orientacao	= NEW.nr_seq_orientacao
				and	c.nr_atendimento	= nr_atendimento_w);
BEGIN
  BEGIN

select	cd_pessoa_fisica,
	nr_atendimento,
	nr_seq_diag
into STRICT	cd_pessoa_fisica_w,
	nr_atendimento_w,
	nr_seq_diag_w
from	checkup_diagnostico
where	nr_sequencia	= NEW.nr_seq_diag;

BEGIN
select	b.nr_sequencia,
	b.ds_orientacao,
	b.nr_seq_apresent
into STRICT	nr_seq_orientacao_w,
	ds_orientacao_w,
	nr_seq_apres_w
from	checkup_tipo_orientacao b
where	b.nr_sequencia	= NEW.nr_seq_orientacao
and	not exists (	SELECT	1
			from	checkup_orientacao c
			where	c.nr_seq_orientacao	= b.nr_sequencia
			and	c.nr_atendimento	= nr_atendimento_w);
exception
when others then
	nr_seq_orientacao_w	:= 0;
end;

if (nr_seq_orientacao_w > 0) then
	select	nextval('checkup_orientacao_seq')
	into STRICT	nr_seq_orient_w
	;

	insert into checkup_orientacao(
		nr_sequencia,
		nr_atendimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_orientacao,
		cd_pessoa_fisica,
		dt_registro,
		ds_orientacao,
		nr_seq_impressao)
	Values (
		nr_seq_orient_w,
		nr_atendimento_W,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		nr_seq_orientacao_w,
		cd_pessoa_fisica_w,
		LOCALTIMESTAMP,
		ds_orientacao_w,
		nr_seq_apres_w);
end if;

  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_checkup_diag_pac_orient_insert() FROM PUBLIC;

CREATE TRIGGER checkup_diag_pac_orient_insert
	AFTER INSERT ON checkup_diag_pac_orient FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_checkup_diag_pac_orient_insert();

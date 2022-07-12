-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS orcamento_custo_atual ON orcamento_custo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_orcamento_custo_atual() RETURNS trigger AS $BODY$
declare

cd_empresa_w	bigint;
nr_seq_ng_w	bigint;

BEGIN

if (NEW.nr_seq_ng is null) then
	BEGIN
	cd_empresa_w	:= obter_empresa_estab(NEW.cd_estabelecimento);

	select	max(nr_sequencia)
	into STRICT	nr_seq_ng_w
	from	natureza_gasto
	where	cd_empresa		= cd_empresa_w
	and	coalesce(cd_estabelecimento, NEW.cd_estabelecimento)	= NEW.cd_estabelecimento
	and	cd_natureza_gasto	= NEW.cd_natureza_gasto;

	if (nr_seq_ng_w is not null) then
		NEW.nr_seq_ng	:= nr_seq_ng_w;
	end if;
	end;
elsif (NEW.cd_natureza_gasto is null) then
	select	max(cd_natureza_gasto)
	into STRICT	NEW.cd_natureza_gasto
	from	natureza_gasto
	where	nr_sequencia	= NEW.nr_seq_ng;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_orcamento_custo_atual() FROM PUBLIC;

CREATE TRIGGER orcamento_custo_atual
	BEFORE INSERT OR UPDATE ON orcamento_custo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_orcamento_custo_atual();

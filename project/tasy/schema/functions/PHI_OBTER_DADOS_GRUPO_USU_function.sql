-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function phi_obter_dados_grupo_usu as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION phi_obter_dados_grupo_usu ( nr_seq_grupo_ger_p bigint, nr_seq_grupo_des_p bigint, nr_seq_grupo_sup_p bigint, nm_usuario_grupo_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, ie_nvl_periodo_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM phi_obter_dados_grupo_usu_atx ( ' || quote_nullable(nr_seq_grupo_ger_p) || ',' || quote_nullable(nr_seq_grupo_des_p) || ',' || quote_nullable(nr_seq_grupo_sup_p) || ',' || quote_nullable(nm_usuario_grupo_p) || ',' || quote_nullable(dt_inicio_vigencia_p) || ',' || quote_nullable(dt_fim_vigencia_p) || ',' || quote_nullable(ie_nvl_periodo_p) || ',' || quote_nullable(ie_opcao_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION phi_obter_dados_grupo_usu_atx ( nr_seq_grupo_ger_p bigint, nr_seq_grupo_des_p bigint, nr_seq_grupo_sup_p bigint, nm_usuario_grupo_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, ie_nvl_periodo_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_gerencia_w	gerencia_wheb.nr_sequencia%type;
nr_seq_grupo_ger_w	gerencia_wheb_grupo.nr_sequencia%type;
nr_seq_grupo_des_w	grupo_desenvolvimento.nr_sequencia%type;
nr_seq_grupo_sup_w	grupo_suporte.nr_sequencia%type;
nr_seq_usuario_ger_w	gerencia_wheb_grupo_usu.nr_sequencia%type;
nr_seq_usuario_des_w	usuario_grupo_des.nr_sequencia%type;
nr_seq_usuario_sup_w	usuario_grupo_sup.nr_sequencia%type;/*	ie_opcao_p
	G - Sequencia da gerencia
	GG - Sequencia do grupo gerencial
	GD - Sequencia do grupo desenvolvimento
	GS - Sequencia do grupo suporte	
	UG - Sequencia do usuario no grupo gerencial
	UD - Sequencia do usuario no grupo desenvolvimento
	US - Sequencia do usuario no grupo suporte
*/
BEGIN

begin
if (nr_seq_grupo_ger_p IS NOT NULL AND nr_seq_grupo_ger_p::text <> '')  then
	begin
	select	a.nr_sequencia,
		b.nr_sequencia
	into STRICT	nr_seq_gerencia_w,
		nr_seq_grupo_ger_w
	from	gerencia_wheb_grupo b,
		gerencia_wheb a
	where	a.nr_sequencia = b.nr_seq_gerencia
	and	b.nr_sequencia = nr_seq_grupo_ger_p;
	
	if (nr_seq_grupo_ger_w IS NOT NULL AND nr_seq_grupo_ger_w::text <> '') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_grupo_des_w
		from	grupo_desenvolvimento
		where	nr_seq_grupo_gerencia = nr_seq_grupo_ger_w;

		if (coalesce(nr_seq_grupo_des_w::text, '') = '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_grupo_sup_w
			from	grupo_suporte
			where	nr_seq_grupo_gerencia = nr_seq_grupo_ger_w;
		end if;
		end;
	end if;
	end;
elsif (nr_seq_grupo_des_p IS NOT NULL AND nr_seq_grupo_des_p::text <> '') then
	begin
	select	a.nr_sequencia,
		b.nr_sequencia,
		c.nr_sequencia
	into STRICT	nr_seq_gerencia_w,
		nr_seq_grupo_ger_w,
		nr_seq_grupo_des_w
	FROM gerencia_wheb a, grupo_desenvolvimento c
LEFT OUTER JOIN gerencia_wheb_grupo b ON (c.nr_seq_grupo_gerencia = b.nr_sequencia)
WHERE a.nr_sequencia = c.nr_seq_gerencia  and c.nr_sequencia = nr_seq_grupo_des_p;
	end;
elsif (nr_seq_grupo_sup_p IS NOT NULL AND nr_seq_grupo_sup_p::text <> '') then
	begin
	select	a.nr_sequencia,
		b.nr_sequencia,
		c.nr_sequencia
	into STRICT	nr_seq_gerencia_w,
		nr_seq_grupo_ger_w,
		nr_seq_grupo_sup_w
	FROM gerencia_wheb a, grupo_suporte c
LEFT OUTER JOIN gerencia_wheb_grupo b ON (c.nr_seq_grupo_gerencia = b.nr_sequencia)
WHERE a.nr_sequencia = c.nr_seq_gerencia_sup  and c.nr_sequencia = nr_seq_grupo_sup_p;
	end;
end if;

if (ie_opcao_p = 'G') then
	return nr_seq_gerencia_w;
elsif (ie_opcao_p = 'GG') then
	return nr_seq_grupo_ger_w;
elsif (ie_opcao_p = 'GD') then
	return nr_seq_grupo_des_w;
elsif (ie_opcao_p = 'GS') then
	return nr_seq_grupo_sup_w;
elsif (ie_opcao_p = 'UG') then
	begin
	if (nr_seq_grupo_ger_w IS NOT NULL AND nr_seq_grupo_ger_w::text <> '') and (nm_usuario_grupo_p IS NOT NULL AND nm_usuario_grupo_p::text <> '') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_usuario_ger_w
		from	gerencia_wheb_grupo_usu
		where	nr_seq_grupo = nr_seq_grupo_ger_w
		and	nm_usuario_grupo = nm_usuario_grupo_p
		and	((coalesce(ie_nvl_periodo_p,'S') = 'S' and
			coalesce(dt_inicio,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,coalesce(dt_inicio,clock_timestamp())) and
			coalesce(dt_fim,clock_timestamp()) = coalesce(dt_fim_vigencia_p,coalesce(dt_fim,clock_timestamp()))) or (ie_nvl_periodo_p = 'N'
			and coalesce(dt_inicio,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,clock_timestamp()) and
			coalesce(dt_fim,clock_timestamp()) = coalesce(dt_fim_vigencia_p,clock_timestamp())));

		return nr_seq_usuario_ger_w;
		end;
	end if;
	end;
elsif (ie_opcao_p = 'UD') then
	begin
	if (nr_seq_grupo_des_w IS NOT NULL AND nr_seq_grupo_des_w::text <> '') and (nm_usuario_grupo_p IS NOT NULL AND nm_usuario_grupo_p::text <> '') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_usuario_des_w
		from	usuario_grupo_des
		where	nr_seq_grupo = nr_seq_grupo_des_w
		and	nm_usuario_grupo = nm_usuario_grupo_p
		and	((coalesce(ie_nvl_periodo_p,'S') = 'S' and
			coalesce(dt_inicio_vigencia,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,coalesce(dt_inicio_vigencia,clock_timestamp())) and
			coalesce(dt_fim_vigencia,clock_timestamp()) = coalesce(dt_fim_vigencia_p,coalesce(dt_fim_vigencia,clock_timestamp()))) or (ie_nvl_periodo_p = 'N' and
			coalesce(dt_inicio_vigencia,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,clock_timestamp()) and
			coalesce(dt_fim_vigencia,clock_timestamp()) = coalesce(dt_fim_vigencia_p,clock_timestamp())));

		return nr_seq_usuario_des_w;
		end;
	end if;
	end;
elsif (ie_opcao_p = 'US') then
	begin
	if (nr_seq_grupo_sup_w IS NOT NULL AND nr_seq_grupo_sup_w::text <> '') and (nm_usuario_grupo_p IS NOT NULL AND nm_usuario_grupo_p::text <> '') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_usuario_sup_w
		from	usuario_grupo_sup
		where	nr_seq_grupo = nr_seq_grupo_sup_w
		and	nm_usuario_grupo = nm_usuario_grupo_p
		and	((coalesce(ie_nvl_periodo_p,'S') = 'S' and
			coalesce(dt_inicio_vigencia,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,coalesce(dt_inicio_vigencia,clock_timestamp())) and
			coalesce(dt_fim_vigencia,clock_timestamp()) = coalesce(dt_fim_vigencia_p,coalesce(dt_fim_vigencia,clock_timestamp()))) or (ie_nvl_periodo_p = 'N' and
			coalesce(dt_inicio_vigencia,clock_timestamp()) = coalesce(dt_inicio_vigencia_p,clock_timestamp()) and
			coalesce(dt_fim_vigencia,clock_timestamp()) = coalesce(dt_fim_vigencia_p,clock_timestamp())));

		return nr_seq_usuario_sup_w;
		end;
	end if;
	end;
end if;
exception
when others then
	null;
end;

return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION phi_obter_dados_grupo_usu ( nr_seq_grupo_ger_p bigint, nr_seq_grupo_des_p bigint, nr_seq_grupo_sup_p bigint, nm_usuario_grupo_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, ie_nvl_periodo_p text, ie_opcao_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION phi_obter_dados_grupo_usu_atx ( nr_seq_grupo_ger_p bigint, nr_seq_grupo_des_p bigint, nr_seq_grupo_sup_p bigint, nm_usuario_grupo_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, ie_nvl_periodo_p text, ie_opcao_p text) FROM PUBLIC;


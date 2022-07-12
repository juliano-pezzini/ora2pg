-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ps_obter_canal_venda ( nr_seq_cliente_p bigint) RETURNS varchar AS $body$
DECLARE


ds_channel_w		varchar(15);
cd_cnpj_canal_venda_w	varchar(14);


BEGIN
if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
	begin
	select	coalesce(max(b.cd_cnpj),0)
	into STRICT	cd_cnpj_canal_venda_w
	from	com_canal b,
		com_canal_cliente a
	where	b.nr_sequencia = a.nr_seq_canal
	and	a.nr_seq_cliente = nr_seq_cliente_p
	and	a.ie_tipo_atuacao = 'V'
	and	coalesce(a.dt_fim_atuacao::text, '') = ''
	and	coalesce(a.ie_situacao,'A') = 'A';

	if (cd_cnpj_canal_venda_w = '0') then
		begin
		ds_channel_w := null;
		end;
	elsif (cd_cnpj_canal_venda_w = '01950338000177') then
		begin
		ds_channel_w := 'Direct';
		end;
	else	begin
		ds_channel_w := 'Indirect';
		end;
	end if;
	end;
end if;
return ds_channel_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ps_obter_canal_venda ( nr_seq_cliente_p bigint) FROM PUBLIC;

-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_termo_atual_web ( ie_aplicacao_p wsuite_termo_uso.ie_aplicacao%type, ie_tipo_termo_p wsuite_termo_uso.ie_tipo_termo%type, nr_seq_usuario_ops_p bigint, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter a sequencia do termo atual se o mesmo ainda nao foi lido pelo usuario do Portal.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  x] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		wsuite_termo_uso.nr_sequencia%type;
nr_seq_termo_uso_w	wsuite_termo_uso.nr_sequencia%type;
qt_leitura_w		integer;


BEGIN
if (ie_tipo_termo_p = 'TU') then
	select 	max(nr_sequencia)
	into STRICT	nr_seq_termo_uso_w
	from 	wsuite_termo_uso
	where 	coalesce(ie_aplicacao::text, '') = '' 
	and 	ie_aplicacao_ant	= ie_aplicacao_p
	and 	ie_situacao		= 'A'
	and 	ie_tipo_termo		= 'TU'
	and 	cd_estabelecimento	= cd_estabelecimento_p
	and 	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and 	dt_inicio_vigencia <= clock_timestamp()
	and (coalesce(dt_fim_vigencia::text, '') = '' or trunc(dt_fim_vigencia) > trunc(clock_timestamp()));
	
elsif (ie_tipo_termo_p = 'AP') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_termo_uso_w
	from	wsuite_termo_uso
	where	coalesce(ie_aplicacao::text, '') = ''
	and (ie_aplicacao_ant 	= ie_aplicacao_p or coalesce(ie_aplicacao_ant::text, '') = '')
	and	ie_situacao		= 'A'
	and	ie_tipo_termo		= 'AP'
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	dt_inicio_vigencia <= clock_timestamp()
	and (coalesce(dt_fim_vigencia::text, '') = '' or trunc(dt_fim_vigencia) > trunc(clock_timestamp()));
end if;

if (nr_seq_termo_uso_w IS NOT NULL AND nr_seq_termo_uso_w::text <> '') then
	select	count(1) qt_leitura
	into STRICT	qt_leitura_w
	from	wsuite_termo_uso_leitura
	where	ds_login 		= nm_usuario_p
	and (nr_seq_usuario_ops	= nr_seq_usuario_ops_p
		or coalesce(nr_seq_usuario_ops_p::text, '') = '')
	and	nr_seq_termo_uso	= nr_seq_termo_uso_w;
	
	if (qt_leitura_w = 0) then
		ds_retorno_w	:= nr_seq_termo_uso_w;
	end if;
end if;
	
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_termo_atual_web ( ie_aplicacao_p wsuite_termo_uso.ie_aplicacao%type, ie_tipo_termo_p wsuite_termo_uso.ie_tipo_termo%type, nr_seq_usuario_ops_p bigint, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

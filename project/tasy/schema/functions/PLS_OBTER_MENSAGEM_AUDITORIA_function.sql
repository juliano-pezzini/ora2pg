-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_mensagem_auditoria ( nr_sequencia_p bigint, ie_tipo_valor_p text) RETURNS varchar AS $body$
DECLARE


/* Utilizada no campo DS_MENSAGEM_AUDITORIA da PLS_GUIA_PLANO */

/* IE_TIPO_VALOR_P
	G - Guia
	PG - Procedimento guia
	MG - Material guia
	C - Conta
	PC - Procedimento conta
*/
ds_retorno_w			varchar(2000);
nr_seq_proc_w			bigint;
nr_seq_regra_liberacao_w	bigint;
ds_regras_auditoria_w		varchar(2000)	:= '';
qt_regra_existente_w		bigint	:= 0;
nr_seq_mensagem_w		bigint;
ds_mensagem_w			varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_regra_liberacao
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_sequencia_p
	and	ie_status	= 'A'
	and	(nr_seq_regra_liberacao IS NOT NULL AND nr_seq_regra_liberacao::text <> '')
	
union

	SELECT	nr_sequencia,
		nr_seq_regra_liberacao
	from	pls_guia_plano
	where	nr_sequencia	= nr_sequencia_p
	and	ie_estagio	= 1
	and	(nr_seq_regra_liberacao IS NOT NULL AND nr_seq_regra_liberacao::text <> '');


BEGIN
ds_retorno_w	:= '';

if (ie_tipo_valor_p	= 'G') then
	open C01;
	loop
	fetch C01 into
		nr_seq_proc_w,
		nr_seq_regra_liberacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		begin
		select	nr_seq_mensagem,
			pls_obter_dsmensagem_auditoria(nr_seq_mensagem)
		into STRICT	nr_seq_mensagem_w,
			ds_mensagem_w
		from	pls_regra_liberacao
		where	nr_sequencia	= nr_seq_regra_liberacao_w;
		exception
			when others then
			nr_seq_mensagem_w	:= 0;
		end;

		qt_regra_existente_w	:= coalesce(position(nr_seq_mensagem_w in ds_regras_auditoria_w),0);
		if (qt_regra_existente_w	= 0) then
			ds_regras_auditoria_w	:= ds_regras_auditoria_w || ',' || nr_seq_mensagem_w;
			ds_retorno_w	:=  ds_retorno_w || ds_mensagem_w || '; ';
		end if;
		end;
	end loop;
	close C01;
elsif (ie_tipo_valor_p	= 'PG') then
	select	nr_seq_regra_liberacao
	into STRICT	nr_seq_regra_liberacao_w
	from	pls_guia_plano_proc
	where	nr_sequencia	= nr_sequencia_p;

	begin
	select	pls_obter_dsmensagem_auditoria(nr_seq_mensagem)
	into STRICT	ds_retorno_w
	from	pls_regra_liberacao
	where	nr_sequencia	= nr_seq_regra_liberacao_w;
	exception
		when others then
		ds_retorno_w	:= '';
	end;
elsif (ie_tipo_valor_p	= 'MG') then
	select	nr_seq_regra_liberacao
	into STRICT	nr_seq_regra_liberacao_w
	from	pls_guia_plano_mat
	where	nr_sequencia	= nr_sequencia_p;

	begin
	select	pls_obter_dsmensagem_auditoria(nr_seq_mensagem)
	into STRICT	ds_retorno_w
	from	pls_regra_liberacao
	where	nr_sequencia	= nr_seq_regra_liberacao_w;
	exception
		when others then
		ds_retorno_w	:= '';
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_mensagem_auditoria ( nr_sequencia_p bigint, ie_tipo_valor_p text) FROM PUBLIC;

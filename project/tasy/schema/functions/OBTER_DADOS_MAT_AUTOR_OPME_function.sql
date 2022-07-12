-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_mat_autor_opme (nr_seq_agenda_pac_opme_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p
E	Sequência Estágio
D	Descrição do Estágio
QA	Quantidade autorizada
*/
nr_sequencia_autor_w		bigint;
nr_seq_estagio_w		bigint	:= null;
ds_estagio_w			varchar(255)	:= null;
ds_retorno_w			varchar(255)	:= null;
qt_autorizada_w			double precision	:= null;


BEGIN

begin
select	nr_sequencia_autor,
	qt_autorizada
into STRICT	nr_sequencia_autor_w,
	qt_autorizada_w
from	material_autorizado
where	nr_seq_opme	= nr_seq_agenda_pac_opme_p  LIMIT 1;
exception
when others then
	nr_sequencia_autor_w	:= null;
	qt_autorizada_w		:= null;
end;

if (nr_sequencia_autor_w IS NOT NULL AND nr_sequencia_autor_w::text <> '') then

	select	a.nr_seq_estagio,
		substr(b.ds_estagio,1,255)
	into STRICT	nr_seq_estagio_w,
		ds_estagio_w
	from	autorizacao_convenio a,
		estagio_autorizacao b
	where	a.nr_seq_estagio	= b.nr_sequencia
	and	a.nr_sequencia		= nr_sequencia_autor_w;
end if;

if (ie_opcao_p = 'E') then
	ds_retorno_w	:= nr_seq_estagio_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_estagio_w;
elsif (ie_opcao_p = 'QA') then
	ds_retorno_w	:= qt_autorizada_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_mat_autor_opme (nr_seq_agenda_pac_opme_p bigint, ie_opcao_p text) FROM PUBLIC;

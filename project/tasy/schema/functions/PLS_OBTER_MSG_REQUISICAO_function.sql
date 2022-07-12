-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_msg_requisicao ( nr_seq_requisicao_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Buscar informações da observação da requisição e das mensagens das requisições
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ X ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(4000);
ds_mensagem_w		varchar(255);


C01 CURSOR FOR
	SELECT	substr(ds_mensagem,1,255)
	from	pls_mensagem_requisicao
	where	nr_seq_requisicao	= nr_seq_requisicao_p;


BEGIN

select	substr(ds_observacao,1,255)
into STRICT	ds_retorno_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_p;

ds_retorno_w	:= ds_retorno_w||chr(13);

open C01;
loop
fetch C01 into
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:= ds_retorno_w||chr(13)||ds_mensagem_w;
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_msg_requisicao ( nr_seq_requisicao_p bigint) FROM PUBLIC;

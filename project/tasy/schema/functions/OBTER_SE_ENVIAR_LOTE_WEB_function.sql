-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_enviar_lote_web ( nr_seq_lote_p bigint, ie_nova_importacao_p text default 'N') RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Verificar se o protocolo foi aceito para confirmar o envio do lote.
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ds_retorno_w		varchar(100) := 'S';
qt_registros_w		bigint;


BEGIN

if (ie_nova_importacao_p = 'S') then
	select count(1)
	into STRICT   qt_registros_w
	from   pls_protocolo_conta_imp
	where  nr_seq_lote_protocolo = nr_seq_lote_p
	and    ie_situacao <> 'A';
else

	select count(1)
	into STRICT   qt_registros_w
	from   pls_protocolo_conta
	where  nr_seq_lote_conta = nr_seq_lote_p
	and    ie_situacao <> 'A';
end if;

if (qt_registros_w > 0) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(309478); -- Somente protocolos aceitos podem ser enviados!
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_enviar_lote_web ( nr_seq_lote_p bigint, ie_nova_importacao_p text default 'N') FROM PUBLIC;

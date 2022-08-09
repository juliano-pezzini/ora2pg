-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_envio_emissao_seg ( nr_seq_segurado_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_historico_w			varchar(255);
ds_observacao_w			varchar(255);
nr_seq_seg_historico_w		bigint;
ie_renovacao_carteira_w		varchar(1);
ie_valor_novo_w			varchar(1);


BEGIN

begin
select	ie_renovacao_carteira,
	CASE WHEN ie_renovacao_carteira='N' THEN 'S' WHEN ie_renovacao_carteira='S' THEN 'N'  ELSE 'S' END
into STRICT	ie_renovacao_carteira_w,
	ie_valor_novo_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	ie_renovacao_carteira_w	:= null;
end;

update	pls_segurado
set	ie_renovacao_carteira	= CASE WHEN ie_renovacao_carteira='N' THEN 'S' WHEN ie_renovacao_carteira='S' THEN 'N'  ELSE 'S' END
where	nr_sequencia	= nr_seq_segurado_p;

ds_historico_w	:= 'Valor anterior: '||ie_renovacao_carteira_w||'. Valor atual: '||ie_valor_novo_w;

select	nextval('pls_segurado_historico_seq')
into STRICT	nr_seq_seg_historico_w
;

/*Gerar o histórico de alteração*/

CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '37', clock_timestamp(), ds_historico_w,
				'pls_alterar_envio_emissao_seg', null, null, null,
				null, clock_timestamp(), null, null,
				null, null, null, null,
				nm_usuario_p, 'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_envio_emissao_seg ( nr_seq_segurado_p bigint, nm_usuario_p text) FROM PUBLIC;

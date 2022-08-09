-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_fechar_rodada ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, nr_seq_lance_p bigint, ie_iniciar_nova_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_seq_fornec_w			bigint;
qt_existe_w			bigint;
vl_edital_w			double precision;
vl_item_w				double precision;
ds_erro_w			varchar(255);
qt_empresas_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_fornec_lance
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p
and	coalesce(vl_item::text, '') = ''
and	coalesce(ie_qualificado,'S') = 'S'
and	lic_obter_situacao_fornec(nr_seq_fornec) <> 'I';

select	coalesce(lic_obter_valor_edital(nr_seq_licitacao_p, nr_seq_lic_item_p),0),
	coalesce(lic_obter_valor_vencedor_item(nr_seq_licitacao_p, nr_seq_lic_item_p),0)
into STRICT	vl_edital_w,
	vl_item_w
;

if (qt_existe_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266190);
	--'Não é possível fechar a rodada, pois falta informar o valor do lance para alguns fornecedores. ' ||
	--'Caso o fornecedor  tenha desistido deste lance, informe 0 (zero)');
end if;

update	reg_lic_fornec_lance
set	dt_fechamento_rodada	= clock_timestamp(),
	nm_usuario_fechamento	= nm_usuario_p
where	nr_seq_licitacao		= nr_seq_licitacao_p
and	nr_seq_lic_item		= nr_seq_lic_item_p
and	nr_seq_lance		= nr_seq_lance_p;

insert into reg_lic_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ie_tipo_historico,
	ds_observacao,
	nr_seq_licitacao)
values (	nextval('reg_lic_historico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	'FR',
	WHEB_MENSAGEM_PCK.get_texto(281125) || nr_seq_lance_p || WHEB_MENSAGEM_PCK.get_texto(281126) || nr_seq_lic_item_p || WHEB_MENSAGEM_PCK.get_texto(281127),
	nr_seq_licitacao_p);


/*select para ver quantos fornecedores ainda estão disputando o item*/

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_fornec_lance
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p
and	nr_seq_lance	= nr_seq_lance_p
and	coalesce(vl_item,0)	> 0
and	coalesce(ie_qualificado,'S')	= 'S';


if (ie_iniciar_nova_p = 'S') then
	qt_empresas_w := lic_iniciar_nova_rodada_lance(nr_seq_licitacao_p, nr_seq_lic_item_p, nm_usuario_p, 'N', qt_empresas_w);
end if;

if	((ie_iniciar_nova_p = 'N') or (qt_existe_w = 0)) and (vl_item_w > vl_edital_w) then
	ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281128);
end if;

ds_erro_p := ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_fechar_rodada ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, nr_seq_lance_p bigint, ie_iniciar_nova_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

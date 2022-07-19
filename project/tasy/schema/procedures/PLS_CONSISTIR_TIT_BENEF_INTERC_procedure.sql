-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_tit_benef_interc ( nr_seq_intercambio_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_titular_pf_w		varchar(1);
ds_erro_w		varchar(250);
qt_titular_w		bigint;
qt_intercambio_pf_w	bigint;


BEGIN

ie_titular_pf_w	:= coalesce(obter_valor_param_usuario(1277, 2, Obter_Perfil_Ativo, nm_usuario_p, 0), 'N');

select	count(*)
into STRICT	qt_intercambio_pf_w
from	pls_intercambio
where	nr_sequencia	= nr_seq_intercambio_p
and	coalesce(cd_cgc::text, '') = '';

select	count(*)
into STRICT	qt_titular_w
from	pls_segurado
where	coalesce(nr_seq_titular::text, '') = ''
and	coalesce(dt_rescisao::text, '') = ''
and	nr_seq_intercambio	= nr_seq_intercambio_p;

if (qt_titular_w > 1) and (ie_titular_pf_w = 'S') and (qt_intercambio_pf_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(262183);
	/* Mensagem: É permitido apenas 1 titular para contratos de intercâmbio de pessoa física. Favor verificar o parâmetro [2]. */

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_tit_benef_interc ( nr_seq_intercambio_p bigint, nm_usuario_p text) FROM PUBLIC;


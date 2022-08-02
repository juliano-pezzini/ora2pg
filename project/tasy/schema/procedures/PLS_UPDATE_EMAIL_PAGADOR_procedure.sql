-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_update_email_pagador (ds_email_pagador_p text, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



nr_seq_pagador_w	pls_segurado.nr_seq_pagador%type;
ds_email_w		pls_contrato_pagador.ds_email%type;
ie_envia_cobranca_w	pls_contrato_pagador.ie_envia_cobranca%type;


BEGIN

select	a.nr_seq_pagador,
	b.ds_email,
	b.ie_envia_cobranca
into STRICT	nr_seq_pagador_w,
	ds_email_w,
	ie_envia_cobranca_w
from	pls_segurado a,
	pls_contrato_pagador b
where	b.nr_sequencia = a.nr_seq_pagador
and	a.nr_sequencia = nr_seq_segurado_p;


/* 'E' = Email  */

if (ds_email_w = ds_email_pagador_p)then
	if (ie_envia_cobranca_w <> 'E' and (ds_email_pagador_p IS NOT NULL AND ds_email_pagador_p::text <> '')) then
		update	pls_contrato_pagador
		set	ie_envia_cobranca = 'E'
		where	nr_sequencia = nr_seq_pagador_w;

		insert into pls_pagador_historico(	nr_sequencia, nr_seq_pagador, cd_estabelecimento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico,
			dt_historico, nm_usuario_historico, ds_titulo,ie_tipo_historico,ie_origem)
		values ( nextval('pls_pagador_historico_seq'), nr_seq_pagador_w, cd_estabelecimento_p,
			clock_timestamp(), 'portal',  clock_timestamp(),  'portal',
			'Realizada a alteração do tipo de envio da cobrança para e-mail.Realizado via portal',
			clock_timestamp(), null, 'Alteração do tipo de envio da cobrança','S','P');



	end if;
else
	if (ds_email_pagador_p IS NOT NULL AND ds_email_pagador_p::text <> '') then
		update	pls_contrato_pagador
		set	ds_email = ds_email_pagador_p,
			ie_envia_cobranca = 'E'
		where	nr_sequencia = nr_seq_pagador_w;


		insert into pls_pagador_historico(	nr_sequencia, nr_seq_pagador, cd_estabelecimento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico,
			dt_historico, nm_usuario_historico, ds_titulo,ie_tipo_historico,ie_origem)
		values ( nextval('pls_pagador_historico_seq'), nr_seq_pagador_w, cd_estabelecimento_p,
			clock_timestamp(), 'portal',  clock_timestamp(), 'portal',
			'Realizada alteração de email. E-mail antigo:'||ds_email_w||' e-mail novo:'||ds_email_pagador_p||chr(13)||chr(10)||
			'Realizada a alteração do tipo de envio da cobrança para e-mail. Realizado via portal',
			clock_timestamp(), null, 'Alteração de e-mail e tipo de envio da cobrança','S','P');
	end if;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_update_email_pagador (ds_email_pagador_p text, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;


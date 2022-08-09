-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_barras_tit_pagar ( nr_seq_banco_escrit_barras_p bigint, nr_titulo_p bigint, nr_bloqueto_p text, nr_seq_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cgc_barras_w		varchar(14);
cd_cgc_titulo_w		varchar(14);
cd_pessoa_barras_w	varchar(10);
cd_pessoa_titulo_w		varchar(10);
cd_pessoa_externo_w	varchar(60);
cd_cnpj_raiz_w		pessoa_juridica.cd_cnpj_raiz%type;
cd_cnpj_raiz_barras_w	pessoa_juridica.cd_cnpj_raiz%type;
ie_alt_tit_bloq_barras_w	varchar(1);
ie_vincular_tit_bloq_barras_w	varchar(1);


BEGIN

ie_alt_tit_bloq_barras_w := obter_param_usuario(857, 60, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_alt_tit_bloq_barras_w);
ie_vincular_tit_bloq_barras_w := obter_param_usuario(857, 66, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_vincular_tit_bloq_barras_w);

if (nr_seq_banco_escrit_barras_p IS NOT NULL AND nr_seq_banco_escrit_barras_p::text <> '') and
	(nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '' AND nr_titulo_p <> 0) and (nr_bloqueto_p IS NOT NULL AND nr_bloqueto_p::text <> '') then

	CALL validar_se_barras_vinc_titulo(nr_bloqueto_p,nr_titulo_p);

	select	max(a.cd_cgc),
		max(a.cd_pessoa_fisica),
		max(a.cd_pessoa_externo),
		max(b.cd_cnpj_raiz)
	into STRICT	cd_cgc_barras_w,
		cd_pessoa_barras_w,
		cd_pessoa_externo_w,
		cd_cnpj_raiz_barras_w
	FROM banco_escrit_barras a, coalesce(a.cd_cgc,a
LEFT OUTER JOIN pessoa_juridica b ON (coalesce(a.cd_cgc,a.cd_pessoa_externo) = b.cd_cgc)
WHERE a.nr_sequencia				= nr_seq_banco_escrit_barras_p;

	select	max(a.cd_cgc),
		max(a.cd_pessoa_fisica),
		max(b.cd_cnpj_raiz)
	into STRICT	cd_cgc_titulo_w,
		cd_pessoa_titulo_w,
		cd_cnpj_raiz_w
	FROM titulo_pagar a
LEFT OUTER JOIN pessoa_juridica b ON (a.cd_cgc = b.cd_cgc)
WHERE a.nr_titulo	= nr_titulo_p;

	if	((cd_cgc_titulo_w IS NOT NULL AND cd_cgc_titulo_w::text <> '') and (coalesce(cd_cgc_barras_w,cd_pessoa_externo_w) <> cd_cgc_titulo_w) and (coalesce(cd_cnpj_raiz_barras_w,'X') <> coalesce(cd_cnpj_raiz_w,'Y')) and (substr(coalesce(cd_cgc_barras_w,cd_pessoa_externo_w),1,8) <> substr(cd_cgc_titulo_w,1,8))) or
		((cd_pessoa_titulo_w IS NOT NULL AND cd_pessoa_titulo_w::text <> '') and (coalesce(cd_pessoa_barras_w,cd_pessoa_externo_w) <> cd_pessoa_titulo_w)) then

		/* A pessoa do título é diferente da pessoa do código de barras! */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(251417);

	end if;

	update	banco_escrit_barras
	set	nr_titulo		= nr_titulo_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_banco_escrit_barras_p;

	if (coalesce(ie_vincular_tit_bloq_barras_w, 'N') = 'S') then
		update	titulo_pagar
		set	nr_bloqueto		= nr_bloqueto_p,
			nm_usuario		= nm_usuario_p,
			ie_bloqueto     = 'S'
		where	nr_titulo	= nr_titulo_p;
	end if;

	if (coalesce(ie_alt_tit_bloq_barras_w, 'N') = 'S') then
		update	titulo_pagar
		set	ie_tipo_titulo	= '1',
			nm_usuario		= nm_usuario_p
		where	nr_titulo	= nr_titulo_p;
	end if;

	if (coalesce(nr_seq_escrit_p,0)	= 0) then
		CALL definir_banco_tit_escritural('CP',nr_titulo_p,null,nm_usuario_p,'N');
	else
		CALL definir_banco_tit_escritural('CP',nr_titulo_p,nr_seq_escrit_p,nm_usuario_p,'N');
	end if;

	commit;

end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_barras_tit_pagar ( nr_seq_banco_escrit_barras_p bigint, nr_titulo_p bigint, nr_bloqueto_p text, nr_seq_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

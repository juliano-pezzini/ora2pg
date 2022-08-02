-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_comunic_reemb ( ie_tipo_regra_p pls_reemb_comunic_interna.ie_tipo_regra%type, ds_conteudo_p text, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



nm_usuario_comunic_w	pls_reemb_comunic_interna.nm_usuario_comunic%type;
cd_perfil_w				pls_reemb_comunic_interna.cd_perfil%type;
ds_comunicado_w			pls_reemb_comunic_interna.ds_comunicado%type;
ds_titulo_w				pls_reemb_comunic_interna.ds_titulo%type;
ds_perfil_w				varchar(20) := null;
ie_status_protocolo_w	pls_protocolo_conta.ie_status%type;
ie_status_prot_regra_w	pls_protocolo_conta.ie_status%type;
qtde_regras_status_w	integer;

C01 CURSOR FOR
	SELECT	nm_usuario_comunic,
			cd_perfil,
			ds_comunicado,
			ds_titulo,
			ie_status_protocolo
	from	pls_reemb_comunic_interna
	where (ie_tipo_regra = ie_tipo_regra_p)
	and		coalesce(ie_status_protocolo::text, '') = ''
	and	ie_situacao	= 'A'
	order by 1;

--Caso a regra possuir restrição por status do protocolo
--que coincida com o status do protocolo em questão,
--então executará as regras obtidas nesse cursor.
C02 CURSOR FOR
	SELECT	nm_usuario_comunic,
			cd_perfil,
			ds_comunicado,
			ds_titulo,
			ie_status_protocolo
	from	pls_reemb_comunic_interna
	where (ie_tipo_regra = ie_tipo_regra_p)
	and		ie_status_protocolo = ie_status_protocolo_w
	and		ie_situacao	= 'A'
	order by 1;


BEGIN

select	ie_status
into STRICT	ie_status_protocolo_w
from	pls_protocolo_conta
where 	nr_sequencia = nr_seq_protocolo_p;

select	count(1)
into STRICT	qtde_regras_status_w
from	pls_reemb_comunic_interna a
where 	a.ie_status_protocolo = ie_status_protocolo_w
and (ie_tipo_regra = ie_tipo_regra_p)
and		a.ie_situacao = 'A';


--Se tiver regras com restrição por status do protocolo que coincidam
--com o status do protocolo em questão, então somente enviará comunicação para esses
if (qtde_regras_status_w > 0 ) then
	open C02;
	loop
	fetch C02 into
		nm_usuario_comunic_w,
		cd_perfil_w,
		ds_comunicado_w,
		ds_titulo_w,
		ie_status_prot_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
			ds_perfil_w := To_char(cd_perfil_w) || ',';
		end if;

			CALL gerar_comunic_padrao(clock_timestamp(), ds_titulo_w, ds_comunicado_w || chr(13) || chr(10) || ' ' || ds_conteudo_p,
				nm_usuario_p, 'N', nm_usuario_comunic_w,
				'N', null, ds_perfil_w,	cd_estabelecimento_p,
				null, clock_timestamp(), null,
				null);
		end;
	end loop;
	close C02;

--Se não houver nenhuma regra cuja restrição por status do protocolo
--for igual ao status do protocolo em questão, então envia comunicado
--quando houver regras sem essa restrição
else

	open C01;
	loop
	fetch C01 into
		nm_usuario_comunic_w,
		cd_perfil_w,
		ds_comunicado_w,
		ds_titulo_w,
		ie_status_prot_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
			ds_perfil_w := To_char(cd_perfil_w) || ',';
		end if;

			CALL gerar_comunic_padrao(clock_timestamp(), ds_titulo_w, ds_comunicado_w || chr(13) || chr(10) || ' ' || ds_conteudo_p,
				nm_usuario_p, 'N', nm_usuario_comunic_w,
				'N', null, ds_perfil_w,	cd_estabelecimento_p,
				null, clock_timestamp(), null,
				null);
		end;
	end loop;
	close C01;

end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_comunic_reemb ( ie_tipo_regra_p pls_reemb_comunic_interna.ie_tipo_regra%type, ds_conteudo_p text, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;


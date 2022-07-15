-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_avisar_novo_cliente ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_razao_social_w			varchar(80);
nm_fantasia_w			varchar(80);
ds_municipio_w			varchar(40);
sg_estado_w			pessoa_juridica.sg_estado%type;
ie_resp_implantacao_w		varchar(255);
ds_titulo_w			varchar(255);
ds_mensagem_w			varchar(2000);
nm_pessoa_fisica_w		varchar(100);
nr_seq_canal_w			bigint;
ds_mensagem_qtde_w		varchar(255) := '';
ie_produto_w			varchar(15);
ie_tipo_w				varchar(03);
qt_vidas_w			bigint;
qt_leito_w			integer;
nm_usuario_destino_w		varchar(4000) := '';
cd_estabelecimento_w		smallint;
nm_usuario_w			varchar(15);

C01 CURSOR FOR
SELECT	nm_usuario
from	usuario
where	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_w;


BEGIN

cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

/*open C01;
loop
fetch C01 into	
	nm_usuario_w;
exit when C01%notfound;
	begin
	if	(nvl(nm_usuario_destino_w,'') = '') then
		begin
			nm_usuario_destino_w := nm_usuario_w || ',';
		end;
	else
		nm_usuario_destino_w := nm_usuario_destino_w || ',' || nm_usuario_w;
	end if;
	end;
end loop;
close C01;*/
select	b.ds_razao_social,
	b.nm_fantasia,
	b.ds_municipio,
	b.sg_estado,
	CASE WHEN a.ie_resp_implantacao='W' THEN 'Philips Clinical Informatics'  ELSE 'Distribuidor' END ,
	a.ie_produto,
	a.ie_tipo,
	a.qt_vidas,
	a.qt_leito
into STRICT	ds_razao_social_w,
	nm_fantasia_w,
	ds_municipio_w,
	sg_estado_w,
	ie_resp_implantacao_w,
	ie_produto_w,
	ie_tipo_w,
	qt_vidas_w,
	qt_leito_w
from	pessoa_juridica b,
	com_cliente a
where	a.cd_cnpj	= b.cd_cgc
and	a.nr_sequencia	= nr_sequencia_p;

ds_mensagem_qtde_w := obter_desc_expressao(966659)  || qt_leito_w || chr(13) || chr(10);

if (ie_produto_w = 'O') then
	ds_mensagem_qtde_w := obter_desc_expressao(966661)  || qt_vidas_w || chr(13) || chr(10);
end if;

if (ie_resp_implantacao_w = 'Distribuidor') then
	select	coalesce(max(nr_seq_canal),0)
	into STRICT	nr_seq_canal_w
	from	com_canal_cliente
	where	ie_situacao 	= 'A'
	and	ie_tipo_atuacao	= 'V'
	and	coalesce(dt_fim_atuacao::text, '') = ''
	and	nr_seq_cliente 	= nr_sequencia_p;
	
	if (nr_seq_canal_w > 0) then
		select	substr(obter_desc_canal_atuacao(nr_seq_canal_w),1,255)
		into STRICT	ie_resp_implantacao_w
		;
	end if;
end if;


select	substr(Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'N'),1,100)
into STRICT	nm_pessoa_fisica_w
;

ds_titulo_w	:= 'Novo cliente';
ds_mensagem_w	:= substr('Prezados,' || chr(13) || chr(10) || chr(13) || chr(10) ||
		obter_desc_expressao(966693) || chr(13) || chr(10) || chr(13) || chr(10) ||
		'Nome Fantasia: '|| nm_fantasia_w || chr(13) || chr(10) ||
		'Cidade: '  || ds_municipio_w || '				' || 'UF: '|| sg_estado_w || chr(13) || chr(10) ||
		'Produto: ' || substr(obter_valor_dominio(2668, ie_produto_w),1,255) || chr(13) || chr(10) || 
		'Tipo:  ' 		|| substr(obter_valor_dominio(1316, ie_tipo_w),1,255) || chr(13) || chr(10) || 
		ds_mensagem_qtde_w ||
		obter_desc_expressao(966695) || ' ' || ie_resp_implantacao_w || chr(13) || chr(10) || chr(13) || chr(10) ||
		obter_desc_expressao(966697) || chr(13) || chr(10) || chr(13) || chr(10) ||
		'Atenciosamente, ' || chr(13) || chr(10) ||
		nm_pessoa_fisica_w,1,2000);

CALL gerar_comunic_padrao(clock_timestamp(), ds_titulo_w, ds_mensagem_w, nm_usuario_p, 'S', null, 'N', null, '', cd_estabelecimento_w, null, clock_timestamp(), null, null);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_avisar_novo_cliente ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_0150 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


contador_w		bigint := 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_cpf_w		varchar(14);
nr_cnpj_w		varchar(14);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;
sg_estado_w 		valor_dominio.vl_dominio%type;
cd_municipio_w		varchar(10);
cd_pais_w		varchar(10);
cd_cgc_w		varchar(14);

c01 CURSOR FOR
SELECT	'0150' 									cd_registro,
	a.cd_pessoa_fisica 							cd_participante,
	substr(obter_nome_pf_pj(a.cd_pessoa_fisica, ''), 1, 80) 		nm_participante,
 	coalesce(p.cd_bacen,'01058')							cd_pais,
	'' 									nr_cnpj,
	a.nr_cpf 								nr_cpf,
	'' 									nr_cei,
	'' 									nr_pis,
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, null, 'UF'),1,255) 	sg_estado,
	'' 									nr_inscricao_estadual,
	'' 									nr_inscricacao_estadual_st,
	substr((obter_compl_pf(a.cd_pessoa_fisica, 1, 'CDMDV')),1,7) 		cd_municipio_ibge,
	'' 									nr_inscricao_municipal,
	'' 									nr_suframa
FROM pessoa_fisica a, compl_pessoa_fisica c
LEFT OUTER JOIN pais p ON (c.nr_seq_pais = p.nr_sequencia)
WHERE a.cd_pessoa_fisica = c.cd_pessoa_fisica  and c.ie_tipo_complemento = 1 and exists (	select	c.cd_pessoa_fisica
			from	nota_fiscal n,
					nota_fiscal_item i,
					nota_fiscal_venc v,
					operacao_nota o
			where	i.nr_sequencia = n.nr_sequencia
			and		n.cd_operacao_nf = o.cd_operacao_nf
			and		n.nr_sequencia = v.nr_sequencia
			and	((coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'E')
			or (coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'S'))
			and ((i.cd_material IS NOT NULL AND i.cd_material::text <> '') or (i.cd_procedimento IS NOT NULL AND i.cd_procedimento::text <> ''))
			and 	n.dt_emissao between dt_inicio_p and dt_fim_p
			and	n.cd_estabelecimento = cd_estabelecimento_p
			and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '')
			and 	o.ie_servico = 'S'
			and	n.vl_total_nota > 0
			and	n.ie_situacao = 1
			and	n.cd_pessoa_fisica = a.cd_pessoa_fisica)

union

select	'0150' 												cd_registro,
	d.cd_cgc 											cd_participante,
	substr(obter_nome_pf_pj('', d.cd_cgc), 1, 80) 							nm_participante,
	coalesce(p.cd_bacen,'01058')										cd_pais,
	d.cd_cgc											nr_cnpj,
	'' 												nr_cpf,
	'' 												nr_cei,
	'' 												nr_pis,
	substr(obter_dados_pf_pj(null, d.cd_cgc, 'UF'),1,255) 						sg_estado,
	substr(elimina_caractere_especial(d.nr_inscricao_estadual), 1, 14) 				nr_inscricao_estadual,
	'' 												nr_inscricao_estadual_st,
	substr(d.cd_municipio_ibge || substr(calcula_digito('MODULO10', d.cd_municipio_ibge),1,1),1,7)	cd_municipio_ibge,
	d.nr_inscricao_municipal 									nr_inscricao_municipal,
	'' 												nr_suframa
FROM pessoa_juridica d
LEFT OUTER JOIN pais p ON (d.nr_seq_pais = p.nr_sequencia)
WHERE exists (	select	n.cd_cgc_emitente
			from	nota_fiscal n,
				nota_fiscal_venc v,
				nota_fiscal_item i,
				operacao_nota o
			where	i.nr_sequencia 		= n.nr_sequencia
			and	n.cd_operacao_nf 	= o.cd_operacao_nf
			and	n.nr_sequencia 		= v.nr_sequencia
			and	((coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'E')
			or (coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'S'))
			and ((i.cd_material IS NOT NULL AND i.cd_material::text <> '') or (i.cd_procedimento IS NOT NULL AND i.cd_procedimento::text <> ''))
			and 	n.dt_emissao between dt_inicio_p and dt_fim_p
			and	n.cd_estabelecimento = cd_estabelecimento_p
			and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '')
			and 	o.ie_servico = 'S'
			and	n.vl_total_nota > 0
			and	n.ie_situacao = 1
			and	n.cd_cgc = d.cd_cgc
			and	coalesce(n.cd_pessoa_fisica::text, '') = '') order by 2;

vet01	c01%rowtype;


BEGIN

select	cd_cgc
into STRICT	cd_cgc_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	contador_w := contador_w + 1;

	nr_cpf_w := vet01.nr_cpf;
	nr_cnpj_w := vet01.nr_cnpj;

	if (length(vet01.cd_pais) < 5) then
		cd_pais_w := '0' || substr(vet01.cd_pais,1,4);
	else
		cd_pais_w := vet01.cd_pais;
	end if;

	if (cd_pais_w <> '01058') then
		sg_estado_w 	:= 'EX';
		cd_municipio_w	:= '';
		nr_cpf_w	:= '';
		nr_cnpj_w	:= '';
	else
		sg_estado_w	:= 'DF';
		cd_municipio_w 	:= '5300108';
	end if;

	/*if (vet01.sg_estado = 'DF') then
		cd_municipio_w := '5300108';
	end if;*/
	ds_linha_w	:= substr(	sep_w || vet01.cd_registro 			||
					sep_w || vet01.cd_participante 			||
					sep_w || Elimina_Acentos(vet01.nm_participante) 			||
					sep_w || cd_pais_w 				||
					sep_w || nr_cnpj_w 				||
					sep_w || nr_cpf_w				||
					sep_w || vet01.nr_cei 				||
					sep_w || vet01.nr_pis 				||
					sep_w || sg_estado_w 				||
					sep_w || vet01.nr_inscricao_estadual 		||
					sep_w || vet01.nr_inscricacao_estadual_st 	||
					sep_w || cd_municipio_w				||
					sep_w || vet01.nr_inscricao_municipal 		||
					sep_w || vet01.nr_suframa			|| sep_w, 1, 8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into fis_lfpd_arquivo(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_linha,
						ds_arquivo,
						ds_arquivo_compl,
						cd_registro,
						nr_seq_controle_lfpd)
				values (	nextval('fis_lfpd_arquivo_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_linha_w,
						ds_arquivo_w,
						ds_arquivo_compl_w,
						vet01.cd_registro,
						nr_seq_controle_p);

	if (mod(contador_w,100) = 0) then
		commit;
	end if;

	SELECT * FROM lfpd_registro_0175(nr_seq_controle_p, nm_usuario_p, vet01.nr_cnpj, vet01.cd_participante, cd_estabelecimento_p, dt_inicio_p, dt_fim_p, ds_separador_p, nr_linha_w, nr_seq_registro_w) INTO STRICT nr_linha_w, nr_seq_registro_w;

	end;
end loop;
close c01;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lfpd_registro_0150 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

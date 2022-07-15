-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_anestesia ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_html_p text default 'N') AS $body$
DECLARE


cd_evolucao_w		bigint;
nr_atendimento_w	bigint;
ie_tipo_evolucao_w	varchar(3);
ds_anestesia_w		varchar(32000);
ds_conteudo_orig_w		varchar(32000);
cd_responsavel_w	varchar(10);
dt_liberacao_w		timestamp;
ds_pos_inicio_rtf_w	bigint;
ds_conteudo_w		varchar(32000);
ie_evolucao_clinica_w	varchar(3);
cd_estabelecimento_w	smallint;
cd_pessoa_fisica_w	varchar(10);


BEGIN

select	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	cirurgia
where	nr_cirurgia	= nr_cirurgia_p;

ie_evolucao_clinica_w := obter_param_usuario(872, 526, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_evolucao_clinica_w);

select	cd_responsavel,
		ds_anestesia,
		dt_liberacao
into STRICT	cd_responsavel_w,	
		ds_anestesia_w,
		dt_liberacao_w
from	anestesia_descricao
where	nr_sequencia = nr_sequencia_p;

if (coalesce(nr_cirurgia_p,0) > 0) then
	select	max(nr_atendimento),
			coalesce(max(cd_pessoa_fisica),0)
	into STRICT	nr_atendimento_w,
			cd_pessoa_fisica_w
	from	cirurgia
	where	nr_cirurgia	= nr_cirurgia_p;
else	
	select	max(nr_atendimento),
			coalesce(max(cd_pessoa_fisica),0)
	into STRICT	nr_atendimento_w,
			cd_pessoa_fisica_w
	from	pepo_cirurgia
	where	nr_sequencia = nr_seq_pepo_p;
end if;	

select	ie_tipo_evolucao
into STRICT	ie_tipo_evolucao_w
from	usuario
where	nm_usuario = nm_usuario_p;

if (coalesce(ie_tipo_evolucao_w::text, '') = '') then
	CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(231834);
	/*r a i s e _application_error(-20011,'Tipo de evolucao nao informado para este usuario');*/

end if;

select	nextval('evolucao_paciente_seq')
into STRICT	cd_evolucao_w
;

if (coalesce(ie_html_p, 'N') = 'S') then
	ds_conteudo_w := ds_anestesia_w;
elsif (position('{\rtf' in ds_anestesia_w) = 0) then	
	ds_anestesia_w := wheb_rtf_pck.get_cabecalho ||chr(13)||chr(10)|| replace(ds_anestesia_w, chr(13)||chr(10), chr(13)||chr(10)|| wheb_rtf_pck.get_quebra_linha) ||chr(13)||chr(10)|| wheb_rtf_pck.get_rodape;	
end if;

ds_conteudo_orig_w := ds_anestesia_w;

if ((ds_anestesia_w IS NOT NULL AND ds_anestesia_w::text <> '') and coalesce(ie_html_p, 'N') = 'N') then
	/*Pega o cabecalho do RTF*/

	
	if	((position('viewkind4\uc1\pard\qj\cf1\f0\fs20' in ds_anestesia_w) > 0) or (position('viewkind4\uc1\pard\cf1\f0\fs16' in ds_anestesia_w) > 0)  or (position('viewkind4\uc1\pard\f0\fs24' in ds_anestesia_w) > 0)  or (position('viewkind4\uc1\pard\cf1\fs18' in ds_anestesia_w) > 0)  or (position('\viewkind4\uc1\pard\f0\fs18' in ds_anestesia_w) > 0)  or (position('viewkind4\uc1\pard\cf1\fs20' in ds_anestesia_w) > 0)) then
		begin /*tratamento para quando e inserido via meu texto padrao para nao quebrar o RTF, visto que quando usa APENAS o texto padrao, o RTF fica noutro padrao*/
		ds_conteudo_w := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil Arial;}{\f1\fnil\fcharset0 Arial;}}' ||
						'{\colortbl ;\red0\green0\blue0;}' ||
						'\viewkind4\uc1\pard\cf1\lang1046\f0\fs20 ';
							
		if (position('viewkind4\uc1\pard\qj\cf1\f0\fs20' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('viewkind4\uc1\pard\qj\cf1\f0\fs20' in ds_anestesia_w) + 34;
		elsif (position('viewkind4\uc1\pard\cf1\f0\fs16' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('viewkind4\uc1\pard\cf1\f0\fs16' in ds_anestesia_w) + 31;
		elsif (position('viewkind4\uc1\pard\cf1\fs20' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('viewkind4\uc1\pard\cf1\fs20' in ds_anestesia_w) + 28;			
		elsif (position('viewkind4\uc1\pard\cf1\fs18' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('viewkind4\uc1\pard\cf1\fs18' in ds_anestesia_w) + 28;	
		elsif (position('\viewkind4\uc1\pard\f0\fs18' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('\viewkind4\uc1\pard\f0\fs18' in ds_anestesia_w) + 28;		
		elsif (position('viewkind4\uc1\pard\f0\fs24' in ds_anestesia_w) > 0) then
			ds_pos_inicio_rtf_w := position('viewkind4\uc1\pard\f0\fs24' in ds_anestesia_w) + 27;
		end if;
		
		end;
	else /* esta parte ficou como era antes, para nao impactar nos clientes que usam corretamente*/
		begin
		ds_pos_inicio_rtf_w := position('lang' in ds_anestesia_w);
		if (ds_pos_inicio_rtf_w > 0) then
			ds_pos_inicio_rtf_w := ds_pos_inicio_rtf_w +8;
			ds_conteudo_w := substr(ds_anestesia_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';
		end if;
		end;
	end if;
			
	/*Acrecenta resto do conteudo do RTF*/

	if (ds_pos_inicio_rtf_w > 0) then
		ds_conteudo_w := ds_conteudo_w || '\par '|| substr(ds_anestesia_w,ds_pos_inicio_rtf_w,length(ds_anestesia_w));
	else
		ds_conteudo_w := ds_conteudo_orig_w;
	end if;
end if;


if (coalesce(cd_pessoa_fisica_w,0) > 0) then

	insert into evolucao_paciente(
		cd_evolucao,
		dt_evolucao,
		ie_tipo_evolucao,
		cd_pessoa_fisica,
		dt_atualizacao,
		nm_usuario,
		nr_atendimento,
		ds_evolucao,
		cd_medico,
		dt_liberacao,
		ie_evolucao_clinica,
		ie_recem_nato,
		ie_situacao,
		nr_cirurgia,
		nr_seq_pepo,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (cd_evolucao_w,
		clock_timestamp(),
		ie_tipo_evolucao_w,
		cd_pessoa_fisica_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento_w,
		ds_conteudo_w,
		cd_responsavel_w,
		dt_liberacao_w,
		ie_evolucao_clinica_w,
		'N',
		'A',
		CASE WHEN coalesce(nr_cirurgia_p,0)=0 THEN  null  ELSE nr_cirurgia_p END ,
		CASE WHEN coalesce(nr_seq_pepo_p,0)=0 THEN  null  ELSE nr_seq_pepo_p END ,
		clock_timestamp(),
		nm_usuario_p);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_anestesia ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_html_p text default 'N') FROM PUBLIC;


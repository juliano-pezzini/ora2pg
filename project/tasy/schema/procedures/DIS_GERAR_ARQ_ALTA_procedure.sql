-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dis_gerar_arq_alta ( nr_atendimento_p bigint, dt_alta_p timestamp) AS $body$
DECLARE


arq_texto_w		utl_file.file_type;
ds_linha_arquivo_w		varchar(2000);
nm_arquivo_w		varchar(100);
ds_diretorio_w		varchar(255);
qt_itens_w		integer;
dt_alta_w			timestamp;
nr_atendimento_w		bigint;
ds_setor_atendimento_w	varchar(100);
cd_estabelecimento_w	smallint;
nm_usuario_w		varchar(15);
ie_forma_integracao_w	varchar(1);

C01 CURSOR FOR
SELECT  'EPD' ||
        '|' ||
        TO_CHAR(dt_alta_p, 'MMDDYYYYHHMMSS') ||
        '|' ||
        nr_atendimento_p ||
        '||||' ||
        TO_CHAR(dt_alta_p, 'MMDDYYYYHHMMSS') ||
        '|' ||
        obter_ds_descricao_setor(obter_setor_atendimento(nr_atendimento_p)) ||
        '|SHS|'

WHERE   (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '')
AND     obter_setor_atendimento(nr_atendimento_p) in (select cd_setor_atendimento from dis_regra_setor);

C02 CURSOR FOR
	SELECT  dt_alta_p,
		nr_atendimento_p,
		obter_ds_descricao_setor(obter_setor_atendimento(nr_atendimento_p))
	
	where   (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '')
	and     obter_setor_atendimento(nr_atendimento_p) in (SELECT cd_setor_atendimento from dis_regra_setor);


BEGIN

select	cd_estabelecimento,
	coalesce(nm_usuario_alta, nm_usuario)
into STRICT	cd_estabelecimento_w,
	nm_usuario_w
from	atendimento_paciente
where 	nr_atendimento = nr_atendimento_p;

select  coalesce(max(ie_forma_integracao),'A')
into STRICT	ie_forma_integracao_w
from	dis_parametros_int
where	cd_estabelecimento = cd_estabelecimento_w;

select	substr(obter_valor_param_usuario(3111, 74, Obter_perfil_ativo, '', ''),1,255)
into STRICT	ds_diretorio_w
;

select	count(*)
into STRICT	qt_itens_w

where   (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '')
and     obter_setor_atendimento(nr_atendimento_p) in (SELECT cd_setor_atendimento from dis_regra_setor);

if (ds_diretorio_w IS NOT NULL AND ds_diretorio_w::text <> '') and (ie_forma_integracao_w = 'A') then
	nm_arquivo_w	:= to_char(clock_timestamp(),'MMDDYYYYHHMMSS') || '.pyx';

	if (qt_itens_w > 0) then
		arq_texto_w 	:= utl_file.fopen(ds_diretorio_w,nm_arquivo_w,'W');

		open C01;
		loop
		fetch C01 into
			ds_linha_arquivo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			--gera uma nova linha no arquivo
			utl_file.put_line(arq_texto_w,ds_linha_arquivo_w);
			utl_file.fflush(arq_texto_w);
		end loop;
		close C01;

		--fecha e libera o arquivo
		utl_file.fclose(arq_texto_w);
	end if;
end if;

if (ie_forma_integracao_w = 'B') then
	begin
	open C02;
	loop
	fetch C02 into
		dt_alta_w,
		nr_atendimento_w,
		ds_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into dis_alta_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_alta,
			nr_atendimento,
			ds_setor_atendimento,
			ie_status)
		values (nextval('dis_alta_paciente_seq'),
			clock_timestamp(),
			nm_usuario_w,
			clock_timestamp(),
			nm_usuario_w,
			dt_alta_w,
			nr_atendimento_w,
			ds_setor_atendimento_w,
			'0');

		end;
	end loop;
	close C02;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dis_gerar_arq_alta ( nr_atendimento_p bigint, dt_alta_p timestamp) FROM PUBLIC;

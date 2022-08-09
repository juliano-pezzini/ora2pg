-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_int_unidade_medida ( nr_seq_unidade_medida_p bigint, nm_usuario_p text, ie_status_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_registros_w					bigint;
ie_status_w					varchar(15);
ds_erro_w					varchar(2000);
cd_unidade_medida_int_w				w_int_unidade_medida.cd_unidade_medida%type;
ds_unidade_medida_int_w				w_int_unidade_medida.ds_unidade_medida%type;
ie_situacao_int_w					w_int_unidade_medida.ie_situacao%type;
cd_sistema_ant_int_w				w_int_unidade_medida.cd_sistema_ant%type;



BEGIN

ie_status_w	:= 'OK';

select	count(*)
into STRICT	qt_registros_w
from	w_int_unidade_medida
where   nr_sequencia = nr_seq_unidade_medida_p;

if (qt_registros_w > 0) then
	select 	cd_unidade_medida,
		ds_unidade_medida,
		coalesce(ie_situacao,'A'),
		cd_sistema_ant
	into STRICT 	cd_unidade_medida_int_w,
		ds_unidade_medida_int_w,
		ie_situacao_int_w,
		cd_sistema_ant_int_w
	from	w_int_unidade_medida
	where   nr_sequencia = nr_seq_unidade_medida_p;
else
	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450416,'NR_SEQUENCIA_W=' || NR_SEQ_UNIDADE_MEDIDA_P); /*Não existe nenhum registro na tabela de unidades de medidas com o código #@NR_SEQUENCIA_W#@.*/
end if;

/*CD_UNIDADE_MEDIDA*/

if (ie_status_w = 'OK') and (coalesce(cd_unidade_medida_int_w::text, '') = '') then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450417);/*Favor informar um código de unidade de medida. Campo obrigatório.*/
end if;

/*DS_UNIDADE_MEDIDA*/

if (ie_status_w = 'OK') and (coalesce(ds_unidade_medida_int_w::text, '') = '') then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450418);/*Favor informar uma descrição para a unidade de medida. Campo obrigatório.*/
end if;

/*IE_SITUACAO*/

if (ie_status_w = 'OK') then

	if (coalesce(ie_situacao_int_w::text, '') = '') then

		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450419);/*Favor informar uma situação para a unidade de medida. Campo obrigatório.*/
	else
		if (ie_situacao_int_w not in ('A','I')) then

			ie_status_w	:= 'E';
			ds_erro_w	:= wheb_mensagem_pck.get_Texto(450420);/*Favor informar um valor válido para a situação da unidae de medida.(A para ativo, I para inativo) */
		end if;
	end if;
end if;


if (ie_status_w = 'OK') then


	select	count(*)
	into STRICT	qt_registros_w
	from	unidade_medida
	where	cd_sistema_ant = cd_sistema_ant_int_w;

	if (qt_registros_w = 0) then

		insert into unidade_medida(
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_unidade_medida,
			ds_unidade_medida,
			ie_situacao,
			cd_sistema_ant,
			nr_seq_apresentacao,
			ie_fracao_dose,
			ie_permite_fracionar,
			ie_mult_h_aplic,
			ie_unidade_adm,
			ie_adm_diluicao)
		values (	clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_unidade_medida_int_w,
			ds_unidade_medida_int_w,
			ie_situacao_int_w,
			cd_sistema_ant_int_w,
			999,
			'N',
			'S',
			'N',
			'N',
			'N');
	else

		update	unidade_medida
		set	ds_unidade_medida = ds_unidade_medida_int_w,
			ie_situacao = ie_situacao_int_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	cd_sistema_ant = cd_sistema_ant_int_w;
	end if;
end if;


delete from w_int_unidade_medida
where nr_sequencia = nr_seq_unidade_medida_p;


commit;


ie_status_p		:= ie_status_w;
ds_erro_p		:= ds_erro_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_unidade_medida ( nr_seq_unidade_medida_p bigint, nm_usuario_p text, ie_status_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;

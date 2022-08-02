-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tratar_regra_dt_item ( ie_data_item_p bigint, ie_tipo_item_p text, dt_procedimento_p timestamp, dt_material_p timestamp, dt_entrada_int_p timestamp, dt_alta_int_p timestamp, dt_emissao_p timestamp, dt_atendimento_p timestamp, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text) AS $body$
DECLARE


dt_hora_atend_w		timestamp;
dt_hora_proc_w		timestamp;
dt_hora_mat_w		timestamp;

ds_hora_proc_w		varchar(10);
ds_hora_mat_w		varchar(10);
ds_hora_atend_w		varchar(10);


BEGIN


ie_gerar_ocorrencia_p	:= 'S';

if	((coalesce(dt_procedimento_p::text, '') = '') and (coalesce(dt_material_p::text, '') = '')) then
	 /* 	Se ítem não tiver a data informada e o tipo de regra para o ítem for para data do ítem não informada,
		então, irá gerar ocorrência, caso não for essa a regra, não irá gerar.
	 */
	 ie_gerar_ocorrencia_p	:= 'N';
	 if (ie_data_item_p = 6) then
		ie_gerar_ocorrencia_p := 'S';
	 end if;

end if;


if	((dt_procedimento_p IS NOT NULL AND dt_procedimento_p::text <> '') or (dt_material_p IS NOT NULL AND dt_material_p::text <> '')) then

	if (ie_data_item_p = 1) then

		if (ie_tipo_item_p = '3') then
			if (dt_procedimento_p >= dt_entrada_int_p) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		elsif (ie_tipo_item_p = '4') then

			if (dt_material_p >= dt_entrada_int_p) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;
		end if;

	/*Data do item maior do que a data da alta*/

	elsif (ie_data_item_p = 2) then
		if (ie_tipo_item_p = '3') then
			if (dt_procedimento_p <= dt_alta_int_p) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		elsif (ie_tipo_item_p = '4') then

			if (dt_material_p <= dt_alta_int_p) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		end if;

	/*Data do item menor do que a data emissão da conta*/

	elsif (ie_data_item_p = 3) then

		--No complemento de contas, não há possibilidade de informar segundos nos itens, com isso, com a data referencia da conta pode conter segundos, mesmo que somente exiba hora e minutos
			--Se não truncar temos um comportamento que aparenta ser estranho para o cliente. Ex:
			/*Datas da conta:
				Data de atendimento: 30/01/2015 CID:  Data de nascimento: 25/09/2006
				Hora do atendimento: 09:43:21(Não exibe os 21 segundos)  .
			Data do procedimento/Material:
				dt eralização 30/01/2015 09:43 (Segundos serão sempre zero para os itens, nesse caso, ao comparar as datas, podem ter efeitos indesejados).
			*/
		if (ie_tipo_item_p = '3') then

			if (trunc(dt_procedimento_p,'mi') >= trunc(dt_emissao_p,'mi')) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		elsif (ie_tipo_item_p = '4') then

			if (trunc(dt_material_p,'mi') >= trunc(dt_emissao_p,'mi')) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		end if;

	/*Data do item maior do que a data atual*/

	elsif (ie_data_item_p = 4) then

		if (ie_tipo_item_p = '3') then

			if (dt_procedimento_p <= clock_timestamp()) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		elsif (ie_tipo_item_p = '4') then

			if (dt_material_p <= clock_timestamp()) then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		end if;

	/*Data do item diferente da data do atendimento da conta*/

	elsif (ie_data_item_p = 5) then
		ds_hora_atend_w	:= to_char(trunc(dt_atendimento_p,'mi'),'hh24:mi:ss');
		ds_hora_proc_w	:= to_char(trunc(dt_procedimento_p,'mi'),'hh24:mi:ss');
		ds_hora_mat_w	:= to_char(trunc(dt_material_p,'mi'),'hh24:mi:ss');


		dt_hora_atend_w	:= to_date('01/01/2001 '||ds_hora_atend_w,'dd/mm/yyyy hh24:mi:ss');
		dt_hora_proc_w	:= to_date('01/01/2001 '||ds_hora_proc_w,'dd/mm/yyyy hh24:mi:ss');
		dt_hora_mat_w	:= to_date('01/01/2001 '||ds_hora_mat_w,'dd/mm/yyyy hh24:mi:ss');

		if (ie_tipo_item_p = '3') then
			if (trunc(dt_procedimento_p,'dd') = trunc(dt_atendimento_p,'dd')) and (dt_hora_proc_w	>= dt_hora_atend_w)	then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;

		--No complemento de contas, não há possibilidade de informar segundos nos itens, com isso, com a data referencia da conta pode conter segundos, mesmo que somente exiba hora e minutos
			--Se não truncar temos um comportamento que aparenta ser estranho para o cliente. Ex:
			/*Datas da conta:
				Data de atendimento: 30/01/2015 CID:  Data de nascimento: 25/09/2006
				Hora do atendimento: 09:43:21(Não exibe os 21 segundos)  .
			Data do procedimento/Material:
				dt eralização 30/01/2015 09:43 (Segundos serão sempre zero para os itens, nesse caso, ao comparar as datas, podem ter efeitos indesejados).
			*/
		elsif (ie_tipo_item_p = '4') then

			if (trunc(dt_material_p,'dd') = trunc(dt_atendimento_p,'dd')) and (dt_hora_mat_w	>= dt_hora_atend_w)	then
				ie_gerar_ocorrencia_p	:= 'N';
			end if;
		end if;

	/*Se entrou aqui, então o item possui data informada, então caso o tipo de regra for
	  data do item não informada, não será gerada ocorrência*/
	elsif (ie_data_item_p = 6) then
		ie_gerar_ocorrencia_p := 'N';

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tratar_regra_dt_item ( ie_data_item_p bigint, ie_tipo_item_p text, dt_procedimento_p timestamp, dt_material_p timestamp, dt_entrada_int_p timestamp, dt_alta_int_p timestamp, dt_emissao_p timestamp, dt_atendimento_p timestamp, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_copiar_prot_exames (ie_substituir_p text, cd_pessoa_fisica_p text, ie_receptor_doador_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_seq_unid_atual_w	bigint;
cd_pessoa_fisica_w	varchar(10);

ie_forma_solic_w	varchar(15);
nr_seq_protocolo_w	bigint;
nr_seq_proc_medic_w	bigint;
nr_dia_w		bigint;
nr_mes_w		bigint;
ie_forma_geracao_w	varchar(1);

ie_diabetico_w		varchar(1);

c01 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	tx_receptor
	where	substr(tx_obter_se_paciente_ativo(nr_sequencia),1,1) = 'S'
	and	cd_pessoa_fisica <> cd_pessoa_fisica_p
	and	ie_receptor_doador_p = 'R'
	
union all

	SELECT	cd_pessoa_fisica
	from	tx_doador
	where	cd_pessoa_fisica <> cd_pessoa_fisica_p
	and	ie_tipo_doador	= 'VIV'
	and	ie_receptor_doador_p = 'D';

c02 CURSOR FOR
	SELECT	ie_forma_solic,
		nr_seq_protocolo,
		nr_seq_proc_medic,
		nr_dia,
		nr_mes,
		ie_forma_geracao
	from	tx_pac_prot_exame
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;


BEGIN

open c01;
	loop
	fetch c01 into
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		/* caso solicite substituição remove os atuais antes de incluir */

		if (ie_substituir_p = 'S') then
			delete	from tx_pac_prot_exame
			where	cd_pessoa_fisica 	= cd_pessoa_fisica_w;
		end if;


		open c02;
			loop
			fetch c02 into
				ie_forma_solic_w,
				nr_seq_protocolo_w,
				nr_seq_proc_medic_w,
				nr_dia_w,
				nr_mes_w,
				ie_forma_geracao_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				insert into tx_pac_prot_exame(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_pessoa_fisica,
					ie_forma_solic,
					nr_seq_protocolo,
					nr_seq_proc_medic,
					nr_dia,
					nr_mes,
					ie_forma_geracao
				) values (
					nextval('tx_pac_prot_exame_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_pessoa_fisica_w,
					ie_forma_solic_w,
					nr_seq_protocolo_w,
					nr_seq_proc_medic_w,
					nr_dia_w,
					nr_mes_w,
					ie_forma_geracao_w
				);
			end loop;
		close c02;

	end loop;
close c01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_copiar_prot_exames (ie_substituir_p text, cd_pessoa_fisica_p text, ie_receptor_doador_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;


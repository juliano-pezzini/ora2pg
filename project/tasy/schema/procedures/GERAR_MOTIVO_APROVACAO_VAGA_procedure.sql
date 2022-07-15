-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_motivo_aprovacao_vaga (nr_sequencia_p bigint, nr_seq_motivo_aprovacao_vaga_p bigint, ds_justificativa_aprov_p text) AS $body$
DECLARE


nr_seq_motivo_w 	solic_vaga_motivo_aprov.nr_seq_motivo_historico%type;
ds_motivo_w 		solic_vaga_motivo_aprov.ds_motivo%type;
ds_historico_w		gestao_vaga_hist.ds_historico%type;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_motivo_aprovacao_vaga_p IS NOT NULL AND nr_seq_motivo_aprovacao_vaga_p::text <> '') then
	begin
		update	gestao_vaga
		set	nr_seq_motivo_aprov_vaga = nr_seq_motivo_aprovacao_vaga_p,
			ds_justificativa_aprov = ds_justificativa_aprov_p
		where	nr_sequencia = nr_sequencia_p;

		select	nr_seq_motivo_historico,
				ds_motivo
		into STRICT	nr_seq_motivo_w,
				ds_motivo_w
		from	solic_vaga_motivo_aprov
		where	nr_sequencia = nr_seq_motivo_aprovacao_vaga_p;

		if (nr_seq_motivo_w IS NOT NULL AND nr_seq_motivo_w::text <> '') then

			ds_historico_w := obter_texto_tasy(1026369, null) ||': '|| ds_motivo_w || chr(13) || chr(10) ||
				obter_texto_tasy(1026373, null)||': '|| ds_justificativa_aprov_p;

			CALL gerar_hist_alteracao_status(nr_sequencia_p, nr_seq_motivo_w, 0, ds_historico_w, wheb_usuario_pck.get_nm_usuario);
		end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_motivo_aprovacao_vaga (nr_sequencia_p bigint, nr_seq_motivo_aprovacao_vaga_p bigint, ds_justificativa_aprov_p text) FROM PUBLIC;


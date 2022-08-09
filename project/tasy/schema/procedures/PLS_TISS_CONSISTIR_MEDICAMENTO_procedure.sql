-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tiss_consistir_medicamento ( nr_sequencia_p bigint, ie_tipo_glosa_p text, ie_evento_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* IE_TIPO_GLOSA_P
	C - Conta
	CP - Conta procedimento
	CM - Conta material
	A - Autorização
	AP - Autorização procedimento
	AM - Autorização material
*/
qt_medicamento_imp_w		double precision;
dt_atendimento_w		timestamp;
dt_exclusao_w			timestamp;
nr_seq_material_w		bigint;
ie_mat_data_exclusao_w		varchar(1) := 'N';
nr_seq_conta_w			pls_conta.nr_sequencia%type;



BEGIN

if (ie_tipo_glosa_p = 'CM') then
	begin
		qt_medicamento_imp_w := 0;
		select	nr_seq_material,
			coalesce(qt_material_imp,0),
			dt_atendimento,
			nr_seq_conta
		into STRICT	nr_seq_material_w,
			qt_medicamento_imp_w,
			dt_atendimento_w,
			nr_seq_conta_w
		from	pls_conta_mat
		where	nr_sequencia = nr_sequencia_p;
	exception
	when others then
		qt_medicamento_imp_w := null;
	end;

	if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
		begin
		select	dt_exclusao
		into STRICT	dt_exclusao_w
		from	pls_material
		where	nr_sequencia = nr_seq_material_w;
		exception
		when others then
			dt_exclusao_w := null;
		end;

		if (dt_exclusao_w IS NOT NULL AND dt_exclusao_w::text <> '') and (dt_atendimento_w IS NOT NULL AND dt_atendimento_w::text <> '') and (trunc(dt_atendimento_w) > trunc(dt_exclusao_w)) then
			ie_mat_data_exclusao_w := 'S';
		end if;
	end if;

end if;

if (qt_medicamento_imp_w <= 0) then
	CALL pls_gravar_glosa_tiss('2105',
		null, ie_evento_p,
		nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, nr_seq_conta_w);
end if;

if (ie_mat_data_exclusao_w = 'S') then
	CALL pls_gravar_glosa_tiss('2199',
		'Medicamento com data de exclusão '||dt_exclusao_w||'. Data do medicamento na conta: '||dt_atendimento_w, ie_evento_p,
		nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, nr_seq_conta_w);
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tiss_consistir_medicamento ( nr_sequencia_p bigint, ie_tipo_glosa_p text, ie_evento_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

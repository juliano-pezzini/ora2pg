-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_att_sit_comp_hist () AS $body$
DECLARE


/*
Essa baca é utilizada para atualizar a situação do historico do compartilhamento de risco do beneficiário e inserir a data do ultimo recebimento do compartilhamento do beneficiário
*/
dt_ocorrencia_w		timestamp;
ie_tipo_segurado_w	pls_segurado.ie_tipo_segurado%type;
ie_alterar_tp_seg_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado,
		(SELECT	max(x.nr_sequencia)
		from	pls_segurado_historico x
		where	x.ie_tipo_historico = '102'
		and	coalesce(x.ie_situacao_compartilhamento, 'A') = 'A'
		and	a.nr_sequencia = x.nr_seq_segurado) nr_seq_ultimo_historico,
		ie_tipo_segurado
	from	pls_segurado a
	where	exists (select 	1
			from	pls_segurado_historico x
			where	a.nr_sequencia = x.nr_seq_segurado
			and	x.ie_tipo_historico = '102');

BEGIN

for r_c01_w in c01 loop
	begin
	
	ie_alterar_tp_seg_w	:= 'N';
	
	select	max(dt_ocorrencia_sib)
	into STRICT	dt_ocorrencia_w
	from	pls_segurado_historico
	where	nr_sequencia = r_c01_w.nr_seq_ultimo_historico;
	
	CALL pls_inativar_historico_compart(r_c01_w.nr_seq_segurado, dt_ocorrencia_w, 'Tasy', 'S');
	
	ie_tipo_segurado_w := pls_obter_segurado_data(r_c01_w.nr_seq_segurado, clock_timestamp());
	
	if (ie_tipo_segurado_w <> r_c01_w.ie_tipo_segurado) then
		ie_alterar_tp_seg_w	:= 'S';
	end if;
	
	CALL wheb_usuario_pck.set_ie_executar_trigger('N');
	update	pls_segurado
	set	dt_alteracao_tipo_segurado = dt_ocorrencia_w,
		ie_tipo_segurado = CASE WHEN ie_alterar_tp_seg_w='S' THEN  ie_tipo_segurado_w  ELSE ie_tipo_segurado END ,
		nm_usuario = 'AltDataTipoSeg',
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = r_c01_w.nr_seq_segurado;
	CALL wheb_usuario_pck.set_ie_executar_trigger('S');
	
	update	pls_segurado_historico
	set	ie_situacao_compartilhamento = 'A',
		nm_usuario = 'BacaSitComp',
		dt_atualizacao = clock_timestamp()
	where	nr_seq_segurado = r_c01_w.nr_seq_segurado
	and	coalesce(ie_situacao_compartilhamento::text, '') = ''
	and	ie_tipo_historico = '102';
	
	end;
end loop;

update	pls_segurado_historico
set	ie_situacao_compartilhamento = 'I'
where	ie_tipo_historico <> '102'
and	coalesce(ie_situacao_compartilhamento::text, '') = '';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_att_sit_comp_hist () FROM PUBLIC;

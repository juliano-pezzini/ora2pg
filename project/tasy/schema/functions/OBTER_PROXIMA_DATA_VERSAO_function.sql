-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proxima_data_versao ( dt_base timestamp, nr_seq_ordem_servico_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------

Referencias: 
Obs: Copia  do objeto obter_proxima_versao_escala com alteracoes para incluir a versao
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dt_liberacao_w			timestamp;
ds_mensagem_w 			varchar(32766);
ds_versao_w 			varchar(30);
cd_versao_w 			varchar(30);
primeiros_nr_versao_w 	varchar(30);
ultimos_nr_versao_w 	bigint;


BEGIN
select	min(d.dt_fim)
into STRICT	dt_liberacao_w
from	escala_diaria d
where	d.nr_seq_escala = 21  
and	d.dt_inicio > dt_base;

select	max(ds_observacao)
into STRICT	ds_versao_w
from	escala_diaria d
where	d.nr_seq_escala = 21  
and		d.dt_fim = dt_liberacao_w;
	
	
select	max(obter_desc_expressao_idioma(cd_exp_informacao, ds_informacao, man_obter_idioma_os_local(nr_seq_ordem_servico_p)))
into STRICT	ds_mensagem_w
from	dic_objeto
where	nr_sequencia = 669938
and	ie_tipo_objeto = 'T';
	
if (coalesce(ds_versao_w,'XPTO') <> 'XPTO') then
	select	 ' (' || max(obter_desc_expressao_idioma(cd_exp_informacao, ds_informacao, man_obter_idioma_os_local(nr_seq_ordem_servico_p))) || ' ' || ds_versao_w || ')'
	into STRICT	ds_versao_w
	from	dic_objeto
	where	nr_sequencia = 669871
	and	ie_tipo_objeto = 'T';
else
	ds_versao_w := '';
end if;	

select	max(cd_versao)
into STRICT 	cd_versao_w
from 	aplicacao_tasy_versao
where  	cd_aplicacao_tasy = 'Tasy'
and 	ie_versao_oficial = 'S';

ultimos_nr_versao_w := substr(cd_versao_w, instr(cd_versao_w, '.',-1, 1) + 1 , length(cd_versao_w));
ultimos_nr_versao_w := ultimos_nr_versao_w + 1;
primeiros_nr_versao_w := substr(cd_versao_w, 1, instr(cd_versao_w, '.',-1, 1));

return	ds_mensagem_w || ' ' || PKG_DATE_FORMATERS.to_varchar(dt_liberacao_w,'shortThreeLetterMonth',WHEB_USUARIO_PCK.get_cd_estabelecimento, WHEB_USUARIO_PCK.get_nm_usuario) ||  ds_versao_w ||
 ' (' ||obter_desc_expressao_idioma(648223,'',man_obter_idioma_os_local(nr_seq_ordem_servico_p)) || ' ' ||  primeiros_nr_versao_w || ultimos_nr_versao_w ||  ').';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proxima_data_versao ( dt_base timestamp, nr_seq_ordem_servico_p bigint) FROM PUBLIC;
